defmodule FacilitaPayExercise.Repo.Migrations.CreatePartner do
  use Ecto.Migration

  def change do
    create table(:partners, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
    end
  end
end
