defmodule Trackguests3.PersonsFixtures do
  @moduledoc """
  This module defines test fixtures for Persons.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        name: "John Doe",
        email: "john.doe@example.com",
        phone: "555-1234",
        company: "Test Company",
        visitor_type: "visitor",
        purpose_of_visit: "Business meeting",
        fob: "FOB123",
        memo: "Test visit",
        status: "checked_in",
        check_in_time: DateTime.utc_now()
      })
      |> Trackguests3.Persons.create_person()

    person
  end

  @doc """
  Generate a checked out person.
  """
  def checked_out_person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        name: "Jane Smith",
        email: "jane.smith@example.com",
        phone: "555-5678",
        company: "Another Company",
        visitor_type: "staff",
        purpose_of_visit: "Staff meeting",
        fob: "FOB456",
        memo: "Staff visit",
        status: "checked_out",
        check_in_time: DateTime.add(DateTime.utc_now(), -3600, :second),
        check_out_time: DateTime.utc_now()
      })
      |> Trackguests3.Persons.create_person()

    person
  end
end