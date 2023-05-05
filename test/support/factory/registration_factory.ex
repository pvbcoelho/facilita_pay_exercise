defmodule FacilitaPayExercise.RegistrationFactory do
  @moduledoc """
  This module is responsable for generate new registration
  """

  defmacro __using__(_opts) do
    quote do
      def registration_factory do
        %FacilitaPayExercise.Schemas.Registration{
          name: "name1",
          cpf: "cpf1",
          email: "email1",
          inserted_at: "2023-01-01 00:00:00"
        }
      end
    end
  end
end
