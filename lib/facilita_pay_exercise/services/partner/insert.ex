defmodule FacilitaPayExercise.Services.Partner.Insert do
  alias FacilitaPayExercise.Repo
  alias FacilitaPayExercise.Schemas.Partner

  @spec run(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def run(partner) do
    Partner.changeset(partner)
    |> Repo.insert()
  end
end
