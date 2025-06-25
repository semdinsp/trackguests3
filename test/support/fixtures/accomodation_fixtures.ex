defmodule Trackguests3.AccomodationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Trackguests3.Accomodation` context.
  """

  @doc """
  Generate a residence.
  """
  def residence_fixture(attrs \\ %{}) do
    {:ok, residence} =
      attrs
      |> Enum.into(%{
        address: "some address",
        floor_count: 42,
        logo: "some logo",
        title: "some title"
      })
      |> Trackguests3.Accomodation.create_residence()

    residence
  end

  @doc """
  Generate a rooms.
  """
  def rooms_fixture(attrs \\ %{}) do
    {:ok, rooms} =
      attrs
      |> Enum.into(%{
        accepts_guests: true,
        floor: 42,
        memo: "some memo",
        needs_fob: true,
        title: "some title"
      })
      |> Trackguests3.Accomodation.create_rooms()

    rooms
  end
end
