defmodule Trackguests3.Accomodation.Residence do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "residences" do
    field(:title, :string)
    field(:address, :string)
    field(:floor_count, :integer)
    field(:logo, :binary)
    field(:timezone, :string, default: "America/New_York")

    has_many :rooms, Trackguests3.Accomodation.Rooms
    has_many :users, Trackguests3.Accounts.User, foreign_key: :property_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(residence, attrs) do
    residence
    |> cast(attrs, [:title, :address, :floor_count, :logo, :timezone])
    |> validate_required([:title, :address, :floor_count])
    |> validate_timezone()
  end

  defp validate_timezone(changeset) do
    case get_field(changeset, :timezone) do
      nil -> changeset
      timezone ->
        valid_timezones = [
          "America/New_York", "America/Chicago", "America/Denver", "America/Los_Angeles",
          "America/Phoenix", "America/Anchorage", "Pacific/Honolulu", "America/Toronto",
          "America/Vancouver", "Europe/London", "Europe/Paris", "Europe/Berlin",
          "Europe/Rome", "Europe/Madrid", "Asia/Tokyo", "Asia/Shanghai",
          "Australia/Sydney", "UTC"
        ]
        
        if timezone in valid_timezones do
          changeset
        else
          add_error(changeset, :timezone, "is not a supported timezone")
        end
    end
  end
end
