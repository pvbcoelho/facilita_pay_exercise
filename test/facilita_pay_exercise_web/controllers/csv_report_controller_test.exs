defmodule FacilitaPayExerciseWeb.CsvReportControllerTest do
  use FacilitaPayExerciseWeb.ConnCase, async: true

  @registration %{name: "foo", cpf: "foo", email: "foo"}
  @regex_content_disposition ~r/^attachment; filename=\"DailyRegistrations_\d{14}\.csv\"$/
  @regex_content_disposition_partner ~r/^attachment; filename=\"DailyRegistrationsByPartner_\d{14}\.csv\"$/

  setup %{conn: conn} do
    create_partners_and_registrations()
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "POST /csv_report/DailyRegistrations" do
    test "returns a CSV file `date,quantity` when no filters are given", %{conn: conn} do
      conn = post(conn, Routes.csv_report_path(conn, :create, "DailyRegistrations"))
      asserts_resume(conn, "2023-01-01,2\n2023-01-02,3\n2023-01-03,2\n2023-01-04,2")
    end

    test "returns a CSV file `date,quantity` when start_date is given", %{conn: conn} do
      conn =
        post(conn, Routes.csv_report_path(conn, :create, "DailyRegistrations"), %{
          start_date: "2023-01-01 13:00:00"
        })

      asserts_resume(conn, "2023-01-02,3\n2023-01-03,2\n2023-01-04,2")
    end

    test "returns a CSV file with `date,quantity` when end_date is given", %{conn: conn} do
      conn =
        post(conn, Routes.csv_report_path(conn, :create, "DailyRegistrations"), %{
          end_date: "2023-01-01 13:00:00"
        })

      asserts_resume(conn, "2023-01-01,2")
    end

    test "returns a CSV file with `date,quantity` when start/end date is given", %{conn: conn} do
      conn =
        post(conn, Routes.csv_report_path(conn, :create, "DailyRegistrations"), %{
          start_date: "2023-01-01 13:00:00",
          end_date: "2023-01-02 13:00:00"
        })

      asserts_resume(conn, "2023-01-02,3")
    end

    test "sould return an error when given a wrong start_date format", %{conn: conn} do
      conn =
        post(conn, Routes.csv_report_path(conn, :create, "DailyRegistrations"), %{
          start_date: "foo"
        })

      asserts_invalid_date_format(conn)
    end

    test "sould return an error when given a wrong end_date format", %{conn: conn} do
      conn =
        post(conn, Routes.csv_report_path(conn, :create, "DailyRegistrations"), %{
          end_date: "foo"
        })

      asserts_invalid_date_format(conn)
    end
  end

  describe "POST /csv_report/DailyRegistrationsByPartner" do
    test "returns a CSV file `partner,date,quantity` when no filters are given", %{conn: conn} do
      conn = post(conn, Routes.csv_report_path(conn, :create, "DailyRegistrationsByPartner"))

      asserts_resume(
        conn,
        "partner_1,2023-01-01,1\npartner_1,2023-01-02,1\npartner_1,2023-01-03,1\npartner_2,2023-01-01,1\npartner_2,2023-01-02,1\npartner_2,2023-01-04,1\npartner_3,2023-01-02,1\npartner_3,2023-01-03,1\npartner_3,2023-01-04,1"
      )
    end

    test "returns a CSV file `partner,date,quantity` when start_date is given", %{conn: conn} do
      conn =
        post(conn, Routes.csv_report_path(conn, :create, "DailyRegistrationsByPartner"), %{
          start_date: "2023-01-01 13:00:00"
        })

      asserts_resume(
        conn,
        "partner_1,2023-01-02,1\npartner_1,2023-01-03,1\npartner_2,2023-01-02,1\npartner_2,2023-01-04,1\npartner_3,2023-01-02,1\npartner_3,2023-01-03,1\npartner_3,2023-01-04,1"
      )
    end

    test "returns a CSV file with `partner,date,quantity` when end_date is given", %{conn: conn} do
      conn =
        post(conn, Routes.csv_report_path(conn, :create, "DailyRegistrationsByPartner"), %{
          end_date: "2023-01-01 13:00:00"
        })

      asserts_resume(conn, "partner_1,2023-01-01,1\npartner_2,2023-01-01,1")
    end

    test "returns a CSV file with `partner,date,quantity` when start/end date is given", %{
      conn: conn
    } do
      conn =
        post(conn, Routes.csv_report_path(conn, :create, "DailyRegistrationsByPartner"), %{
          start_date: "2023-01-01 13:00:00",
          end_date: "2023-01-02 13:00:00"
        })

      asserts_resume(
        conn,
        "partner_1,2023-01-02,1\npartner_2,2023-01-02,1\npartner_3,2023-01-02,1"
      )
    end

    test "sould return an error when given a wrong start_date format", %{conn: conn} do
      conn =
        post(conn, Routes.csv_report_path(conn, :create, "DailyRegistrationsByPartner"), %{
          start_date: "foo"
        })

      asserts_invalid_date_format(conn)
    end

    test "sould return an error when given a wrong end_date format", %{conn: conn} do
      conn =
        post(conn, Routes.csv_report_path(conn, :create, "DailyRegistrationsByPartner"), %{
          end_date: "foo"
        })

      asserts_invalid_date_format(conn)
    end
  end

  describe "POST /csv_report/foo" do
    test "sould return not found when given a wrong report_name is given", %{conn: conn} do
      conn =
        post(conn, Routes.csv_report_path(conn, :create, "foo"), %{
          end_date: "foo"
        })

      assert conn.status == 404
      assert conn.resp_body == "{\"error\":\"Report not found: `foo`\"}"
    end
  end

  defp get_value_from_resp_headers(resp_headers, key) do
    resp_headers |> Enum.find_value(fn {k, v} -> if k == key, do: v end)
  end

  defp create_partners_and_registrations() do
    partner = insert(:partner, %{name: "partner_1"})
    insert_registration(partner.id, "2023-01-01 12:00:00")
    insert_registration(partner.id, "2023-01-02 12:00:00")
    insert_registration(partner.id, "2023-01-03 12:00:00")

    partner = insert(:partner, %{name: "partner_2"})
    insert_registration(partner.id, "2023-01-01 12:30:00")
    insert_registration(partner.id, "2023-01-02 12:30:00")
    insert_registration(partner.id, "2023-01-04 12:30:00")

    partner = insert(:partner, %{name: "partner_3"})
    insert_registration(partner.id, "2023-01-02 13:00:00")
    insert_registration(partner.id, "2023-01-03 13:00:00")
    insert_registration(partner.id, "2023-01-04 13:00:00")
  end

  defp insert_registration(partner_id, date) do
    insert(
      :registration,
      Map.merge(@registration, %{partner_id: partner_id, inserted_at: date})
    )
  end

  defp asserts_resume(conn, body) do
    assert conn.status == 200

    content_type = get_value_from_resp_headers(conn.resp_headers, "content-type")
    assert content_type == "application/csv"

    content_disposition = get_value_from_resp_headers(conn.resp_headers, "content-disposition")

    regex =
      case conn.path_params["report_name"] do
        "DailyRegistrationsByPartner" -> @regex_content_disposition_partner
        _ -> @regex_content_disposition
      end

    assert String.match?(content_disposition, regex)

    assert conn.resp_body == body
  end

  defp asserts_invalid_date_format(conn) do
    assert conn.status == 400
    assert conn.resp_body == "{\"error\":\"Invalid date format\"}"
  end
end
