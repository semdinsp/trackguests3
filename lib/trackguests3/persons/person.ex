defmodule Trackguests3.Persons.Person do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "persons" do
    field(:name, :string)
    field(:email, :string)
    field(:phone, :string)
    field(:company, :string)
    field(:purpose_of_visit, :string)
    field(:check_in_time, :utc_datetime)
    field(:check_out_time, :utc_datetime)
    field(:visitor_type, :string, default: "visitor")
    field(:status, :string, default: "checked_out")
    field(:memo, :string)

    belongs_to(:room, Trackguests3.Accomodation.Rooms)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [
      :name,
      :email,
      :phone,
      :company,
      :purpose_of_visit,
      :visitor_type,
      :memo
    ])
    |> validate_required([:name])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_inclusion(:visitor_type, ["visitor", "staff", "resident"])
    |> validate_inclusion(:status, ["checked_in", "checked_out"])
  end

  @doc false
  def check_in_changeset(person, attrs) do
    person
    |> cast(attrs, [:room_id, :check_in_time, :status])
    |> validate_required([:room_id, :check_in_time, :status])
    |> validate_inclusion(:status, ["checked_in"])
    |> foreign_key_constraint(:room_id)
  end

  @doc false
  def check_out_changeset(person, attrs) do
    person
    |> cast(attrs, [:check_out_time, :status])
    |> validate_required([:check_out_time, :status])
    |> validate_inclusion(:status, ["checked_out"])
    |> put_change(:room_id, nil)
  end
end
