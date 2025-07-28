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
    field(:fob, :string)

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
      :memo,
      :fob,
      :room_id,
      :check_in_time,
      :status
    ])
    |> validate_required([:name])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_inclusion(:visitor_type, ["visitor", "staff", "resident"])
    |> validate_inclusion(:status, ["checked_in", "checked_out"])
    |> validate_check_in_requirements()
    |> validate_fob_required_on_create()
    |> foreign_key_constraint(:room_id)
  end

  defp validate_check_in_requirements(changeset) do
    status = get_field(changeset, :status)

    if status == "checked_in" do
      changeset
      |> validate_required([:room_id, :check_in_time], message: "is required when checking in")
    else
      changeset
    end
  end

  defp validate_fob_required_on_create(changeset) do
    status = get_field(changeset, :status)
    room_id = get_field(changeset, :room_id)
    fob = get_field(changeset, :fob)

    if status == "checked_in" && room_id do
      case Trackguests3.Accomodation.get_room(room_id) do
        {:ok, room} when room.needs_fob == true ->
          if is_nil(fob) or String.trim(fob) == "" do
            add_error(changeset, :fob, "is required for this room")
          else
            changeset
          end
        {:ok, _room} ->
          # Room doesn't require fob
          changeset
        {:error, :not_found} ->
          # Room not found - let foreign key constraint handle this
          changeset
      end
    else
      changeset
    end
  end

  @doc false
  def check_in_changeset(person, attrs) do
    person
    |> cast(attrs, [:room_id, :check_in_time, :status, :fob])
    |> validate_required([:room_id, :check_in_time, :status])
    |> validate_inclusion(:status, ["checked_in"])
    |> validate_fob_required()
    |> foreign_key_constraint(:room_id)
  end

  defp validate_fob_required(changeset) do
    room_id = get_field(changeset, :room_id)
    fob = get_field(changeset, :fob)

    if room_id do
      case Trackguests3.Accomodation.get_room(room_id) do
        {:ok, room} when room.needs_fob == true ->
          if is_nil(fob) or String.trim(fob) == "" do
            add_error(changeset, :fob, "is required for this room")
          else
            changeset
          end
        _ ->
          changeset
      end
    else
      changeset
    end
  end

  @doc false
  def check_out_changeset(person, attrs) do
    person
    |> cast(attrs, [:check_out_time, :status])
    |> validate_required([:check_out_time, :status])
    |> validate_inclusion(:status, ["checked_out"])
    # Keep room_id unchanged during checkout to preserve location information
  end
end
