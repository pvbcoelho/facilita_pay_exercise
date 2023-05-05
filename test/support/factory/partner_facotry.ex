defmodule FacilitaPayExercise.PartnerFactory do
  @moduledoc """
  This module is responsable for generate new partner
  """

  defmacro __using__(_opts) do
    quote do
      def partner_factory do
        %FacilitaPayExercise.Schemas.Partner{
          name: "awsome partner"
        }
      end
    end
  end
end
