defmodule FacilitaPayExercise.Repo.Migrations.CreateRegistration do
  use Ecto.Migration

  def change do
    create table(:registrations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :partner_id, references(:partners, type: :uuid), null: false

      add :name, :string, null: false
      add :cpf, :string, null: false
      add :email, :string, null: false
      add :inserted_at, :utc_datetime, null: false
    end
  end
end
