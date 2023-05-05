defmodule FacilitaPayExerciseWeb.CsvReportController do
  use FacilitaPayExerciseWeb, :controller

  alias FacilitaPayExercise.Services.Report

  action_fallback FacilitaPayExerciseWeb.FallbackController

  def create(conn, %{"report_name" => report_name} = params) do
    with {:ok, csv} <- Report.csv(report_name, params) do
      conn
      |> send_download({:binary, csv.report},
        filename: csv.filename,
        content_type: "application/csv"
      )
    end
  end
end
