defmodule FacilitaPayExercise.Services.Registration.Insert do
  alias FacilitaPayExercise.Repo
  alias FacilitaPayExercise.Schemas.Registration

  @spec run(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def run(registration) do
    Registration.changeset(registration)
    |> Repo.insert()
  end
end
