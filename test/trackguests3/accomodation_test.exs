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
end