defmodule Trackguests3.Persons do
  @moduledoc """
  The Persons context for managing visitors and guests.
  """

  import Ecto.Query, warn: false
  alias Trackguests3.Repo

  alias Trackguests3.Persons.Person

  @doc """
  Returns the list of persons, optionally limited by a residence filter from
  `Trackguests3.Accounts.residence_filter/1` (default: all).

  ## Examples

      iex> list_persons()
      [%Person{}, ...]

  """
  def list_persons(filter \\ :all)

  def list_persons(:all), do: Repo.all(Person)

  def list_persons({:only, residence_id}) do
    from(p in Person,
      join: r in assoc(p, :room),
      where: r.residence_id == ^residence_id
    )
    |> Repo.all()
  end

  def list_persons(:none), do: []

  @doc """
  Returns the total number of persons (guests and visitors).
  """
  def count_persons, do: Repo.aggregate(Person, :count, :id)

  @doc """
  Returns the list of currently checked-in persons.
  """
  def list_checked_in_persons do
    from(p in Person, where: p.status == "checked_in")
    |> Repo.all()
  end

  @doc """
  Returns the list of currently checked-in visitors for a specific residence.
  """
  def list_current_visitors_for_residence(residence_id) do
    from(p in Person,
      join: r in assoc(p, :room),
      where: p.status == "checked_in" and r.residence_id == ^residence_id,
      preload: [:room]
    )
    |> Repo.all()
  end

  @doc """
  Returns the checked-in visits among `person_ids` that belong to the given
  residence. Used by self-service check-out, where `person_ids` come from the
  guest's own signed cookie, so a phone only ever sees its own visits.
  """
  def list_self_service_visits(person_ids, residence_id) when is_list(person_ids) do
    ids = Enum.filter(person_ids, &valid_uuid?/1)

    from(p in Person,
      join: r in assoc(p, :room),
      where: p.id in ^ids and p.status == "checked_in" and r.residence_id == ^residence_id,
      order_by: [desc: p.check_in_time],
      preload: [:room]
    )
    |> Repo.all()
  end

  def list_self_service_visits(_, _), do: []

  @doc """
  Checks out a visit on behalf of the guest's phone. Only succeeds when the
  visit is in `person_ids` (the phone's own visits), is checked in, and
  belongs to the residence whose QR code was scanned.
  """
  def self_check_out(person_id, person_ids, residence_id) do
    if person_id in List.wrap(person_ids) do
      case list_self_service_visits([person_id], residence_id) do
        [person] -> check_out_person(person)
        [] -> {:error, :not_found}
      end
    else
      {:error, :not_found}
    end
  end

  defp valid_uuid?(id), do: is_binary(id) and match?({:ok, _}, Ecto.UUID.cast(id))

  @doc """
  Returns the list of persons for a specific room.
  """
  def list_persons_by_room(room_id) do
    from(p in Person, where: p.room_id == ^room_id)
    |> Repo.all()
  end

  @doc """
  Gets a single person.

  Raises `Ecto.NoResultsError` if the Person does not exist.

  ## Examples

      iex> get_person!(123)
      %Person{}

      iex> get_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_person!(id), do: Repo.get!(Person, id)

  @doc """
  Creates a person.

  ## Examples

      iex> create_person(%{field: value})
      {:ok, %Person{}}

      iex> create_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Checks in a person to a room.
  """
  def check_in_person(person, room_id) do
    person
    |> Person.check_in_changeset(%{
      room_id: room_id,
      check_in_time: DateTime.utc_now(),
      status: "checked_in",
      fob: person.fob
    })
    |> Repo.update()
  end

  @doc """
  Checks out a person from their current room.
  """
  def check_out_person(person) do
    person
    |> Person.check_out_changeset(%{
      check_out_time: DateTime.utc_now(),
      status: "checked_out"
    })
    |> Repo.update()
  end

  @doc """
  Checks out a visitor by ID.
  """
  def check_out_visitor(visitor_id) do
    case get_person!(visitor_id) do
      person ->
        check_out_person(person)
    end
  end

  @doc """
  Updates a person.

  ## Examples

      iex> update_person(person, %{field: new_value})
      {:ok, %Person{}}

      iex> update_person(person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a person.

  ## Examples

      iex> delete_person(person)
      {:ok, %Person{}}

      iex> delete_person(person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person(%Person{} = person) do
    Repo.delete(person)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person changes.

  ## Examples

      iex> change_person(person)
      %Ecto.Changeset{}}

  """
  def change_person(%Person{} = person, attrs \\ %{}) do
    Person.changeset(person, attrs)
  end
end
