defmodule Trackguests3.Accomodation do
  @moduledoc """
  The Accomodation context.
  """

  import Ecto.Query, warn: false
  alias Trackguests3.Repo

  alias Trackguests3.Accomodation.Residence

  @doc """
  Returns the list of residences.

  ## Examples

      iex> list_residences()
      [%Residence{}, ...]

  """
  def list_residences do
    Repo.all(Residence)
  end

  @doc """
  Gets a single residence.

  Raises `Ecto.NoResultsError` if the Residence does not exist.

  ## Examples

      iex> get_residence!(123)
      %Residence{}

      iex> get_residence!(456)
      ** (Ecto.NoResultsError)

  """
  def get_residence!(id), do: Repo.get!(Residence, id)

  @doc """
  Creates a residence.

  ## Examples

      iex> create_residence(%{field: value})
      {:ok, %Residence{}}

      iex> create_residence(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_residence(attrs) do
    %Residence{}
    |> Residence.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a residence.

  ## Examples

      iex> update_residence(residence, %{field: new_value})
      {:ok, %Residence{}}

      iex> update_residence(residence, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_residence(%Residence{} = residence, attrs) do
    residence
    |> Residence.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a residence.

  ## Examples

      iex> delete_residence(residence)
      {:ok, %Residence{}}

      iex> delete_residence(residence)
      {:error, %Ecto.Changeset{}}

  """
  def delete_residence(%Residence{} = residence) do
    Repo.delete(residence)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking residence changes.

  ## Examples

      iex> change_residence(residence)
      %Ecto.Changeset{data: %Residence{}}

  """
  def change_residence(%Residence{} = residence, attrs \\ %{}) do
    Residence.changeset(residence, attrs)
  end

  alias Trackguests3.Accomodation.Rooms

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Rooms{}, ...]

  """
  def list_rooms do
    Repo.all(Rooms)
  end

  @doc """
  Gets a single rooms.

  Raises `Ecto.NoResultsError` if the Rooms does not exist.

  ## Examples

      iex> get_rooms!(123)
      %Rooms{}

      iex> get_rooms!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rooms!(id), do: Repo.get!(Rooms, id)

  @doc """
  Creates a rooms.

  ## Examples

      iex> create_rooms(%{field: value})
      {:ok, %Rooms{}}

      iex> create_rooms(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rooms(attrs) do
    %Rooms{}
    |> Rooms.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rooms.

  ## Examples

      iex> update_rooms(rooms, %{field: new_value})
      {:ok, %Rooms{}}

      iex> update_rooms(rooms, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rooms(%Rooms{} = rooms, attrs) do
    rooms
    |> Rooms.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rooms.

  ## Examples

      iex> delete_rooms(rooms)
      {:ok, %Rooms{}}

      iex> delete_rooms(rooms)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rooms(%Rooms{} = rooms) do
    Repo.delete(rooms)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rooms changes.

  ## Examples

      iex> change_rooms(rooms)
      %Ecto.Changeset{{}}

  """
  def change_rooms(%Rooms{} = rooms, attrs \\ %{}) do
    Rooms.changeset(rooms, attrs)
  end

  # Dashboard Statistics Functions

  @doc """
  Gets comprehensive dashboard statistics.

  Returns a map with key metrics for the dashboard.
  """
  def get_dashboard_stats do
    %{
      total_residences: count_residences(),
      total_rooms: count_rooms(),
      current_guests: count_current_guests(),
      occupancy_rate: calculate_occupancy_rate(),
      recent_activity: get_recent_activity()
    }
  end

  @doc """
  Returns the total count of residences.
  """
  def count_residences do
    Repo.aggregate(Residence, :count, :id)
  end

  @doc """
  Returns the total count of rooms across all residences.
  """
  def count_rooms do
    Repo.aggregate(Rooms, :count, :id)
  end

  @doc """
  Returns the count of currently checked-in guests.
  For now returns 0 since persons/guests aren't fully implemented yet.
  """
  def count_current_guests do
    alias Trackguests3.Persons

    from(p in Persons.Person, where: p.status == "checked_in")
    |> Repo.aggregate(:count, :id)

    # Fallback to 0 if no persons table exists
  end

  @doc """
  Calculates the current occupancy rate as a percentage.
  Returns 0.0 if no rooms exist.
  """
  def calculate_occupancy_rate do
    total_rooms = count_rooms()
    current_guests = count_current_guests()

    if total_rooms > 0 do
      (current_guests / total_rooms * 100)
      |> Float.round(1)
    else
      0.0
    end
  end

  @doc """
  Gets recent activity for the dashboard.
  Returns a list of recent actions like new residences, rooms created, etc.
  """
  def get_recent_activity do
    recent_residences =
      from(r in Residence,
        order_by: [desc: r.inserted_at],
        limit: 3,
        select: %{
          type: "residence_created",
          title: r.title,
          inserted_at: r.inserted_at,
          id: r.id
        }
      )
      |> Repo.all()

    recent_rooms =
      from(rm in Rooms,
        join: res in Residence,
        on: rm.residence_id == res.id,
        order_by: [desc: rm.inserted_at],
        limit: 3,
        select: %{
          type: "room_created",
          title: fragment("? || ' - ' || ?", res.title, rm.title),
          inserted_at: rm.inserted_at,
          id: rm.id
        }
      )
      |> Repo.all()

    (recent_residences ++ recent_rooms)
    |> Enum.sort_by(& &1.inserted_at, {:desc, DateTime})
    |> Enum.take(5)
  end

  @doc """
  Gets residences with room counts for dashboard display.
  """
  def list_residences_with_stats do
    from(r in Residence,
      left_join: rm in Rooms,
      on: rm.residence_id == r.id,
      group_by: r.id,
      select: %{
        id: r.id,
        title: r.title,
        address: r.address,
        floor_count: r.floor_count,
        room_count: count(rm.id),
        inserted_at: r.inserted_at
      },
      order_by: [desc: r.inserted_at]
    )
    |> Repo.all()
  end
end
