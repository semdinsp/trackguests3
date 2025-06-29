defmodule Trackguests3.Persons do
  @moduledoc """
  The Persons context for managing visitors and guests.
  """

  import Ecto.Query, warn: false
  alias Trackguests3.Repo

  alias Trackguests3.Persons.Person

  @doc """
  Returns the list of persons.

  ## Examples

      iex> list_persons()
      [%Person{}, ...]

  """
  def list_persons do
    Repo.all(Person)
  end

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
      status: "checked_in"
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
