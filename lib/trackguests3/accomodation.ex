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
  Returns the list of rooms with preloaded residence data.

  ## Examples

      iex> list_rooms_with_residences()
      [%Rooms{residence: %Residence{}}, ...]

  """
  def list_rooms_with_residences do
    Rooms
    |> Repo.all()
    |> Repo.preload(:residence)
  end

  @doc """
  Returns the list of rooms for a specific residence.

  ## Examples

      iex> list_rooms_for_residence(residence_id)
      [%Rooms{}, ...]

  """
  def list_rooms_for_residence(residence_id) do
    from(r in Rooms, where: r.residence_id == ^residence_id)
    |> Repo.all()
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
  Gets a single room safely.

  Returns {:ok, room} if found, {:error, :not_found} otherwise.

  ## Examples

      iex> get_room(123)
      {:ok, %Rooms{}}

      iex> get_room(456)
      {:error, :not_found}

  """
  def get_room(id) do
    case Repo.get(Rooms, id) do
      nil -> {:error, :not_found}
      room -> {:ok, room}
    end
  end

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

  @doc """
  Creates multiple rooms from CSV data for a residence.
  
  ## Examples
  
      iex> create_rooms_from_csv(residence_id, csv_data)
      {:ok, %{created: 5, errors: []}}
      
      iex> create_rooms_from_csv(residence_id, invalid_csv_data)
      {:error, "Invalid CSV format"}
  """
  def create_rooms_from_csv(residence_id, csv_content) when is_binary(csv_content) do
    case parse_csv_rooms(csv_content) do
      {:ok, room_data} ->
        create_rooms_bulk(residence_id, room_data)
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Parses CSV content and returns room data.
  
  Expected CSV format:
  title,floor,needs_fob,memo,accepts_guests
  Room 101,1,true,Corner room,true
  Room 102,1,false,Standard room,true
  """
  def parse_csv_rooms(csv_content) do
    try do
      lines = String.split(csv_content, "\n", trim: true)
      
      case lines do
        [] ->
          {:error, "Empty CSV file"}
          
        [header | data_lines] ->
          expected_headers = ["title", "floor", "needs_fob", "memo", "accepts_guests"]
          actual_headers = 
            header
            |> String.split(",")
            |> Enum.map(&String.trim/1)
            |> Enum.map(&String.downcase/1)
          
          if actual_headers == expected_headers do
            rooms = 
              data_lines
              |> Enum.with_index(2)
              |> Enum.reduce([], fn {line, line_number}, acc ->
                case parse_csv_line(line, line_number) do
                  {:ok, room_data} -> [room_data | acc]
                  {:error, _} -> acc  # Skip invalid lines
                end
              end)
              |> Enum.reverse()
            
            {:ok, rooms}
          else
            {:error, "Invalid CSV headers. Expected: #{Enum.join(expected_headers, ", ")}"}
          end
      end
    rescue
      _ -> {:error, "Invalid CSV format"}
    end
  end

  defp parse_csv_line(line, line_number) do
    try do
      [title, floor, needs_fob, memo, accepts_guests] = 
        line
        |> String.split(",")
        |> Enum.map(&String.trim/1)
      
      parsed_floor = 
        case Integer.parse(floor) do
          {num, ""} -> num
          _ -> raise "Invalid floor number"
        end
      
      parsed_needs_fob = parse_boolean(needs_fob)
      parsed_accepts_guests = parse_boolean(accepts_guests)
      
      {:ok, %{
        title: title,
        floor: parsed_floor,
        needs_fob: parsed_needs_fob,
        memo: memo,
        accepts_guests: parsed_accepts_guests
      }}
    rescue
      _ -> {:error, "Invalid data on line #{line_number}"}
    end
  end

  defp parse_boolean(value) do
    case String.downcase(String.trim(value)) do
      val when val in ["true", "yes", "1", "y"] -> true
      val when val in ["false", "no", "0", "n"] -> false
      _ -> false  # Default to false for invalid values
    end
  end

  defp create_rooms_bulk(residence_id, room_data) do
    results = 
      room_data
      |> Enum.map(fn room_attrs ->
        room_attrs
        |> Map.put(:residence_id, residence_id)
        |> create_rooms()
      end)
    
    {created, errors} = 
      results
      |> Enum.reduce({0, []}, fn
        {:ok, _room}, {created_count, errors} ->
          {created_count + 1, errors}
        {:error, changeset}, {created_count, errors} ->
          error_msg = 
            changeset.errors
            |> Enum.map(fn {field, {msg, _}} -> "#{field}: #{msg}" end)
            |> Enum.join(", ")
          {created_count, [error_msg | errors]}
      end)
    
    {:ok, %{created: created, errors: Enum.reverse(errors)}}
  end
end
