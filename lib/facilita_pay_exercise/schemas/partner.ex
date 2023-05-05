defmodule FacilitaPayExercise.Schemas.Partner do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "partners" do
    field :name, :string
    has_many :registrations, FacilitaPayExercise.Schemas.Registration, on_delete: :delete_all
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
