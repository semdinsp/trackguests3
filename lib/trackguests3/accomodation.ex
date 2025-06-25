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
      %Ecto.Changeset{data: %Rooms{}}

  """
  def change_rooms(%Rooms{} = rooms, attrs \\ %{}) do
    Rooms.changeset(rooms, attrs)
  end
end
