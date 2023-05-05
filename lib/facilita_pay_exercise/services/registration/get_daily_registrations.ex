defmodule FacilitaPayExercise.Services.Registration.GetDailyRegistrations do
  import Ecto.Query

  alias FacilitaPayExercise.Repo
  alias FacilitaPayExercise.Schemas.Partner
  alias FacilitaPayExercise.Schemas.Registration

  @spec run!(report_name :: String.t(), opts :: Keyword.t()) :: list()
  def run!(report_name, opts \\ [])

  def run!("DailyRegistrations", opts) do
    query =
      from r in Registration,
        where: ^start_date(opts[:start_date]),
        where: ^end_date(opts[:end_date]),
        order_by: [asc: r.inserted_at],
        select: %{date: fragment("TO_CHAR(?, 'YYYY-MM-DD')", r.inserted_at)}

    Repo.all(query)
  end

  def run!("DailyRegistrationsByPartner", opts) do
    query =
      from r in Registration,
        join: p in Partner,
        on: r.partner_id == p.id,
        where: ^start_date(opts[:start_date]),
        where: ^end_date(opts[:end_date]),
        order_by: [asc: p.name, asc: r.inserted_at],
        select: %{
          date: fragment("TO_CHAR(?, 'YYYY-MM-DD')", r.inserted_at),
          partner_name: p.name
        }

    Repo.all(query)
  end

  defp start_date(nil), do: true
  defp start_date(""), do: true
  defp start_date(start_date), do: dynamic([r], r.inserted_at >= ^start_date)

  defp end_date(nil), do: true
  defp end_date(""), do: true
  defp end_date(end_date), do: dynamic([r], r.inserted_at <= ^end_date)
end
