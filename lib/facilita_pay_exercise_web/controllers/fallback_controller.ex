defmodule FacilitaPayExerciseWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use FacilitaPayExerciseWeb, :controller

  def call(conn, {:error, status, message: message}) do
    conn
    |> put_status(status)
    |> json(%{"error" => message})
  end
end
