defmodule FacilitaPayExercise.Factory do
  @moduledoc """
  This module is responsable for create factory.
  """
  use ExMachina.Ecto, repo: FacilitaPayExercise.Repo

  use FacilitaPayExercise.{
    PartnerFactory,
    RegistrationFactory
  }
end
