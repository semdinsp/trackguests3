defmodule Trackguests3.Accomodation.Residence do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "residences" do
    field :title, :string
    field :address, :string
    field :floor_count, :integer
    field :logo, :binary

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(residence, attrs) do
    residence
    |> cast(attrs, [:title, :address, :floor_count, :logo])
    |> validate_required([:title, :address, :floor_count, :logo])
  end
end
