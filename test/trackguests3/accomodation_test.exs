defmodule Trackguests3.AccomodationTest do
  use Trackguests3.DataCase

  alias Trackguests3.Accomodation

  describe "residences" do
    alias Trackguests3.Accomodation.Residence

    import Trackguests3.AccomodationFixtures

    @invalid_attrs %{address: nil, title: nil, logo: nil, floor_count: nil}

    test "list_residences/0 returns all residences" do
      residence = residence_fixture()
      assert Accomodation.list_residences() == [residence]
    end

    test "get_residence!/1 returns the residence with given id" do
      residence = residence_fixture()
      assert Accomodation.get_residence!(residence.id) == residence
    end

    test "create_residence/1 with valid data creates a residence" do
      valid_attrs = %{address: "some address", title: "some title", logo: "some logo", floor_count: 42}

      assert {:ok, %Residence{} = residence} = Accomodation.create_residence(valid_attrs)
      assert residence.address == "some address"
      assert residence.title == "some title"
      assert residence.logo == "some logo"
      assert residence.floor_count == 42
    end

    test "create_residence/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accomodation.create_residence(@invalid_attrs)
    end

    test "update_residence/2 with valid data updates the residence" do
      residence = residence_fixture()
      update_attrs = %{address: "some updated address", title: "some updated title", logo: "some updated logo", floor_count: 43}

      assert {:ok, %Residence{} = residence} = Accomodation.update_residence(residence, update_attrs)
      assert residence.address == "some updated address"
      assert residence.title == "some updated title"
      assert residence.logo == "some updated logo"
      assert residence.floor_count == 43
    end

    test "update_residence/2 with invalid data returns error changeset" do
      residence = residence_fixture()
      assert {:error, %Ecto.Changeset{}} = Accomodation.update_residence(residence, @invalid_attrs)
      assert residence == Accomodation.get_residence!(residence.id)
    end

    test "delete_residence/1 deletes the residence" do
      residence = residence_fixture()
      assert {:ok, %Residence{}} = Accomodation.delete_residence(residence)
      assert_raise Ecto.NoResultsError, fn -> Accomodation.get_residence!(residence.id) end
    end

    test "change_residence/1 returns a residence changeset" do
      residence = residence_fixture()
      assert %Ecto.Changeset{} = Accomodation.change_residence(residence)
    end
  end

  describe "rooms" do
    alias Trackguests3.Accomodation.Rooms

    import Trackguests3.AccomodationFixtures

    @invalid_attrs %{floor: nil, title: nil, needs_fob: nil, memo: nil, accepts_guests: nil}

    test "list_rooms/0 returns all rooms" do
      rooms = rooms_fixture()
      assert Accomodation.list_rooms() == [rooms]
    end

    test "get_rooms!/1 returns the rooms with given id" do
      rooms = rooms_fixture()
      assert Accomodation.get_rooms!(rooms.id) == rooms
    end

    test "create_rooms/1 with valid data creates a rooms" do
      valid_attrs = %{floor: 42, title: "some title", needs_fob: true, memo: "some memo", accepts_guests: true}

      assert {:ok, %Rooms{} = rooms} = Accomodation.create_rooms(valid_attrs)
      assert rooms.floor == 42
      assert rooms.title == "some title"
      assert rooms.needs_fob == true
      assert rooms.memo == "some memo"
      assert rooms.accepts_guests == true
    end

    test "create_rooms/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accomodation.create_rooms(@invalid_attrs)
    end

    test "update_rooms/2 with valid data updates the rooms" do
      rooms = rooms_fixture()
      update_attrs = %{floor: 43, title: "some updated title", needs_fob: false, memo: "some updated memo", accepts_guests: false}

      assert {:ok, %Rooms{} = rooms} = Accomodation.update_rooms(rooms, update_attrs)
      assert rooms.floor == 43
      assert rooms.title == "some updated title"
      assert rooms.needs_fob == false
      assert rooms.memo == "some updated memo"
      assert rooms.accepts_guests == false
    end

    test "update_rooms/2 with invalid data returns error changeset" do
      rooms = rooms_fixture()
      assert {:error, %Ecto.Changeset{}} = Accomodation.update_rooms(rooms, @invalid_attrs)
      assert rooms == Accomodation.get_rooms!(rooms.id)
    end

    test "delete_rooms/1 deletes the rooms" do
      rooms = rooms_fixture()
      assert {:ok, %Rooms{}} = Accomodation.delete_rooms(rooms)
      assert_raise Ecto.NoResultsError, fn -> Accomodation.get_rooms!(rooms.id) end
    end

    test "change_rooms/1 returns a rooms changeset" do
      rooms = rooms_fixture()
      assert %Ecto.Changeset{} = Accomodation.change_rooms(rooms)
    end
  end
end
