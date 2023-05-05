defmodule FacilitaPayExercise.Services.Report do
  alias FacilitaPayExercise.Services.Registration.GetDailyRegistrations

  @valid_report_names ["DailyRegistrations", "DailyRegistrationsByPartner"]

  @spec csv(String.t(), map()) :: {:ok, map()} | {:error, String.t()}

  def csv(report_name, opts \\ %{})

  def csv(report_name, opts) when report_name in @valid_report_names do
    parsed_opts = [
      start_date: opts["start_date"],
      end_date: opts["end_date"]
    ]

    report =
      GetDailyRegistrations.run!(report_name, parsed_opts)
      |> build_report()

    {:ok, %{filename: build_file_name(report_name), report: report}}
  rescue
    error ->
      case error do
        %Ecto.Query.CastError{} ->
          {:error, :bad_request, message: "Invalid date format"}

        error ->
          error
      end
  end

  def csv(invalid_report_name, _opts),
    do: {:error, :not_found, message: "Report not found: `#{invalid_report_name}`"}

  def build_report(registrations) do
    registrations
    |> group_registrations
    |> join_grouped_registrations
  end

  defp group_registrations(registrations) do
    case hd(registrations) do
      %{partner_name: _any} -> count_and_group_by_partner(registrations)
      _ -> count_and_group_by_date(registrations)
    end
  end

  defp count_and_group_by_partner(list) do
    list
    |> Enum.group_by(&{&1.partner_name, &1.date})
    |> Enum.map(fn {{partner, date}, group} ->
      %{partner_name: partner, date: date, count: Enum.count(group)}
    end)
  end

  defp count_and_group_by_date(list) do
    list
    |> Enum.group_by(&{&1.date})
    |> Enum.map(fn {{date}, group} ->
      %{date: date, count: Enum.count(group)}
    end)
  end

  defp join_grouped_registrations(registrations) do
    registrations
    |> Enum.map(fn row ->
      case row[:partner_name] do
        nil ->
          Enum.join([row[:date], row[:count]], ",")

        partner_name ->
          Enum.join([partner_name, row[:date], row[:count]], ",")
      end
    end)
    |> Enum.join("\n")
  end

  defp build_file_name(report_name) do
    now_utc =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)
      |> to_string
      |> String.replace(~r/[^0-9]/, "")

    "#{report_name}_#{now_utc}.csv"
  end
end
