defmodule Trackguests3.Accomodation.Rooms do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rooms" do
    field(:title, :string)
    field(:floor, :integer)
    field(:needs_fob, :boolean, default: false)
    field(:memo, :string)
    field(:accepts_guests, :boolean, default: false)

    belongs_to(:residence, Trackguests3.Accomodation.Residence)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(rooms, attrs) do
    rooms
    |> cast(attrs, [:title, :floor, :needs_fob, :memo, :accepts_guests, :residence_id])
    |> validate_required([:title, :floor, :needs_fob, :memo, :accepts_guests])
  end
end
