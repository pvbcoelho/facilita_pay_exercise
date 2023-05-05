defmodule FacilitaPayExercise.Schemas.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  alias FacilitaPayExercise.Schemas.Partner

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_fields [:partner_id, :name, :cpf, :email, :inserted_at]
  schema "registrations" do
    field :name, :string
    field :cpf, :string
    field :email, :string
    field :inserted_at, :utc_datetime

    belongs_to :partner, Partner
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
