defmodule Trackguests3.AccomodationTest do
  use Trackguests3.DataCase

  alias Trackguests3.Accomodation

  import Trackguests3.AccomodationFixtures

  describe "CSV room import" do
    test "parse_csv_rooms/1 parses valid CSV content" do
      csv_content = """
      title,floor,needs_fob,memo,accepts_guests
      Room 101,1,true,Corner room,true
      Room 102,1,false,Standard room,false
      Room 201,2,true,Suite with balcony,true
      """

      assert {:ok, rooms} = Accomodation.parse_csv_rooms(csv_content)
      assert length(rooms) == 3

      [room1, room2, room3] = rooms

      assert room1.title == "Room 101"
      assert room1.floor == 1
      assert room1.needs_fob == true
      assert room1.memo == "Corner room"
      assert room1.accepts_guests == true

      assert room2.title == "Room 102"
      assert room2.floor == 1
      assert room2.needs_fob == false
      assert room2.memo == "Standard room"
      assert room2.accepts_guests == false

      assert room3.title == "Room 201"
      assert room3.floor == 2
      assert room3.needs_fob == true
      assert room3.memo == "Suite with balcony"
      assert room3.accepts_guests == true
    end

    test "parse_csv_rooms/1 handles different boolean formats" do
      csv_content = """
      title,floor,needs_fob,memo,accepts_guests
      Room 101,1,yes,Test,no
      Room 102,2,1,Test,0
      Room 103,3,true,Test,false
      """

      assert {:ok, rooms} = Accomodation.parse_csv_rooms(csv_content)
      assert length(rooms) == 3

      [room1, room2, room3] = rooms

      assert room1.needs_fob == true
      assert room1.accepts_guests == false

      assert room2.needs_fob == true
      assert room2.accepts_guests == false

      assert room3.needs_fob == true
      assert room3.accepts_guests == false
    end

    test "parse_csv_rooms/1 returns error for invalid headers" do
      csv_content = """
      wrong,headers,here
      Room 101,1,true
      """

      assert {:error, error_msg} = Accomodation.parse_csv_rooms(csv_content)
      assert error_msg =~ "Invalid CSV headers"
    end

    test "parse_csv_rooms/1 returns error for empty CSV" do
      assert {:error, "Empty CSV file"} = Accomodation.parse_csv_rooms("")
    end

    test "create_rooms_from_csv/2 creates rooms successfully" do
      residence = residence_fixture()

      csv_content = """
      title,floor,needs_fob,memo,accepts_guests
      Room 101,1,true,Corner room,true
      Room 102,1,false,Standard room,false
      """

      assert {:ok, %{created: 2, errors: []}} = 
        Accomodation.create_rooms_from_csv(residence.id, csv_content)

      rooms = Accomodation.list_rooms_for_residence(residence.id)
      assert length(rooms) == 2

      room_titles = Enum.map(rooms, & &1.title)
      assert "Room 101" in room_titles
      assert "Room 102" in room_titles
    end

    test "create_rooms_from_csv/2 handles invalid CSV" do
      residence = residence_fixture()

      invalid_csv = """
      wrong,headers
      Room 101,1
      """

      assert {:error, error_msg} = Accomodation.create_rooms_from_csv(residence.id, invalid_csv)
      assert error_msg =~ "Invalid CSV headers"

      # Should not create any rooms
      rooms = Accomodation.list_rooms_for_residence(residence.id)
      assert length(rooms) == 0
    end
  end

  describe "residence timezone functionality" do
    test "create_residence/1 with valid timezone" do
      valid_attrs = %{
        title: "Test Residence",
        address: "123 Test St",
        floor_count: 5,
        timezone: "America/Los_Angeles"
      }

      assert {:ok, %Accomodation.Residence{} = residence} = Accomodation.create_residence(valid_attrs)
      assert residence.timezone == "America/Los_Angeles"
      assert residence.title == "Test Residence"
    end

    test "create_residence/1 with default timezone" do
      valid_attrs = %{
        title: "Test Residence",
        address: "123 Test St",
        floor_count: 5
      }

      assert {:ok, %Accomodation.Residence{} = residence} = Accomodation.create_residence(valid_attrs)
      assert residence.timezone == "America/New_York"
    end

    test "create_residence/1 with invalid timezone" do
      invalid_attrs = %{
        title: "Test Residence",
        address: "123 Test St",
        floor_count: 5,
        timezone: "Invalid/Timezone"
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Accomodation.create_residence(invalid_attrs)
      assert "is not a supported timezone" in errors_on(changeset).timezone
    end

    test "update_residence/2 with valid timezone" do
      residence = residence_fixture()
      
      update_attrs = %{timezone: "Europe/London"}

      assert {:ok, %Accomodation.Residence{} = updated_residence} = 
        Accomodation.update_residence(residence, update_attrs)
      assert updated_residence.timezone == "Europe/London"
    end

    test "update_residence/2 with invalid timezone" do
      residence = residence_fixture()
      
      update_attrs = %{timezone: "Not/Valid"}

      assert {:error, %Ecto.Changeset{} = changeset} = 
        Accomodation.update_residence(residence, update_attrs)
      assert "is not a supported timezone" in errors_on(changeset).timezone
    end

    test "get_supported_timezones/0 returns list of timezone options" do
      timezones = Accomodation.get_supported_timezones()
      
      assert is_list(timezones)
      assert length(timezones) > 0
      
      # Check that it returns tuples with display names and timezone values
      assert Enum.all?(timezones, fn
        {display_name, timezone_value} when is_binary(display_name) and is_binary(timezone_value) -> true
        _ -> false
      end)
      
      # Check that default EST timezone is included
      assert {"Eastern Time (EST/EDT)", "America/New_York"} in timezones
    end

    test "format_datetime_in_timezone/2 with valid timezone" do
      # Create a test datetime using DateTime.utc_now for test simplicity
      datetime = DateTime.utc_now()
      
      # Test formatting in different timezones
      est_formatted = Accomodation.format_datetime_in_timezone(datetime, "America/New_York")
      pst_formatted = Accomodation.format_datetime_in_timezone(datetime, "America/Los_Angeles")
      
      assert is_binary(est_formatted)
      assert is_binary(pst_formatted)
      assert est_formatted =~ ~r/\d{1,2}:\d{2} (AM|PM)/
      assert pst_formatted =~ ~r/\d{1,2}:\d{2} (AM|PM)/
      
      # Both should be properly formatted time strings
      # Note: The actual time difference depends on timezone conversion working properly
    end

    test "format_datetime_in_timezone/2 with invalid timezone falls back gracefully" do
      datetime = DateTime.utc_now()
      
      formatted = Accomodation.format_datetime_in_timezone(datetime, "Invalid/Timezone")
      
      # Should fallback to original datetime formatting
      assert is_binary(formatted)
      assert formatted =~ ~r/\d{1,2}:\d{2} (AM|PM)/
    end

    test "format_datetime_in_timezone/2 with nil timezone falls back gracefully" do
      datetime = DateTime.utc_now()
      
      formatted = Accomodation.format_datetime_in_timezone(datetime, nil)
      
      # Should fallback to original datetime formatting
      assert is_binary(formatted)
      assert formatted =~ ~r/\d{1,2}:\d{2} (AM|PM)/
    end
  end
end