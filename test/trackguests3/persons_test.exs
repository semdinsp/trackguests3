defmodule Trackguests3.PersonsTest do
  use Trackguests3.DataCase

  alias Trackguests3.Persons
  alias Trackguests3.Persons.Person
  alias Trackguests3.Accomodation

  @valid_person_attrs %{
    name: "John Doe",
    email: "john@example.com",
    phone: "+1234567890",
    company: "Test Company",
    purpose_of_visit: "Business meeting",
    visitor_type: "visitor",
    memo: "Test memo"
  }

  @valid_residence_attrs %{
    title: "Test Residence",
    address: "123 Test St",
    floor_count: 3
  }

  @valid_room_attrs %{
    title: "Room 101",
    floor: 1,
    needs_fob: false,
    memo: "Test room",
    accepts_guests: true
  }

  @valid_room_with_fob_attrs %{
    title: "Room 201", 
    floor: 2,
    needs_fob: true,
    memo: "Secure room",
    accepts_guests: true
  }

  describe "person schema" do
    test "changeset with valid attributes" do
      changeset = Person.changeset(%Person{}, @valid_person_attrs)
      assert changeset.valid?
    end

    test "changeset includes fob field" do
      attrs = Map.put(@valid_person_attrs, :fob, "FOB123")
      changeset = Person.changeset(%Person{}, attrs)
      assert changeset.valid?
      assert get_change(changeset, :fob) == "FOB123"
    end
  end

  describe "check_in_changeset" do
    setup do
      {:ok, residence} = Accomodation.create_residence(@valid_residence_attrs)
      
      {:ok, room_no_fob} = 
        @valid_room_attrs
        |> Map.put(:residence_id, residence.id)
        |> Accomodation.create_rooms()
      
      {:ok, room_with_fob} = 
        @valid_room_with_fob_attrs
        |> Map.put(:residence_id, residence.id)
        |> Accomodation.create_rooms()

      {:ok, person} = Persons.create_person(@valid_person_attrs)

      %{
        person: person,
        room_no_fob: room_no_fob,
        room_with_fob: room_with_fob
      }
    end

    test "check-in succeeds for room that doesn't require fob", %{person: person, room_no_fob: room} do
      attrs = %{
        room_id: room.id,
        check_in_time: DateTime.utc_now(),
        status: "checked_in"
      }
      
      changeset = Person.check_in_changeset(person, attrs)
      assert changeset.valid?
    end

    test "check-in succeeds for room that requires fob when fob is provided", %{person: person, room_with_fob: room} do
      attrs = %{
        room_id: room.id,
        check_in_time: DateTime.utc_now(),
        status: "checked_in",
        fob: "FOB123"
      }
      
      changeset = Person.check_in_changeset(person, attrs)
      assert changeset.valid?
    end

    test "check-in fails for room that requires fob when fob is not provided", %{person: person, room_with_fob: room} do
      attrs = %{
        room_id: room.id,
        check_in_time: DateTime.utc_now(),
        status: "checked_in"
      }
      
      changeset = Person.check_in_changeset(person, attrs)
      refute changeset.valid?
      assert changeset.errors[:fob] == {"is required for this room", []}
    end

    test "check-in fails for room that requires fob when fob is empty string", %{person: person, room_with_fob: room} do
      attrs = %{
        room_id: room.id,
        check_in_time: DateTime.utc_now(),
        status: "checked_in",
        fob: ""
      }
      
      changeset = Person.check_in_changeset(person, attrs)
      refute changeset.valid?
      assert changeset.errors[:fob] == {"is required for this room", []}
    end

    test "check-in fails for room that requires fob when fob is whitespace", %{person: person, room_with_fob: room} do
      attrs = %{
        room_id: room.id,
        check_in_time: DateTime.utc_now(),
        status: "checked_in",
        fob: "   "
      }
      
      changeset = Person.check_in_changeset(person, attrs)
      refute changeset.valid?
      assert changeset.errors[:fob] == {"is required for this room", []}
    end
  end

  describe "check_in_person/2" do
    setup do
      {:ok, residence} = Accomodation.create_residence(@valid_residence_attrs)
      
      {:ok, room_no_fob} = 
        @valid_room_attrs
        |> Map.put(:residence_id, residence.id)
        |> Accomodation.create_rooms()
      
      {:ok, room_with_fob} = 
        @valid_room_with_fob_attrs
        |> Map.put(:residence_id, residence.id)
        |> Accomodation.create_rooms()

      %{
        room_no_fob: room_no_fob,
        room_with_fob: room_with_fob
      }
    end

    test "successfully checks in person with fob to room requiring fob", %{room_with_fob: room} do
      {:ok, person} = 
        @valid_person_attrs
        |> Map.put(:fob, "FOB123")
        |> Persons.create_person()

      {:ok, checked_in_person} = Persons.check_in_person(person, room.id)
      
      assert checked_in_person.status == "checked_in"
      assert checked_in_person.room_id == room.id
      assert checked_in_person.fob == "FOB123"
      assert checked_in_person.check_in_time != nil
    end

    test "fails to check in person without fob to room requiring fob", %{room_with_fob: room} do
      {:ok, person} = Persons.create_person(@valid_person_attrs)

      {:error, changeset} = Persons.check_in_person(person, room.id)
      
      refute changeset.valid?
      assert changeset.errors[:fob] == {"is required for this room", []}
    end

    test "successfully checks in person without fob to room not requiring fob", %{room_no_fob: room} do
      {:ok, person} = Persons.create_person(@valid_person_attrs)

      {:ok, checked_in_person} = Persons.check_in_person(person, room.id)
      
      assert checked_in_person.status == "checked_in"
      assert checked_in_person.room_id == room.id
      assert checked_in_person.check_in_time != nil
    end
  end

  describe "single-step check-in via create_person/1" do
    setup do
      {:ok, residence} = Accomodation.create_residence(@valid_residence_attrs)
      
      {:ok, room_no_fob} = 
        @valid_room_attrs
        |> Map.put(:residence_id, residence.id)
        |> Accomodation.create_rooms()
      
      {:ok, room_with_fob} = 
        @valid_room_with_fob_attrs
        |> Map.put(:residence_id, residence.id)
        |> Accomodation.create_rooms()

      %{
        room_no_fob: room_no_fob,
        room_with_fob: room_with_fob
      }
    end

    test "successfully creates person with check-in data for room without fob", %{room_no_fob: room} do
      attrs = Map.merge(@valid_person_attrs, %{
        room_id: room.id,
        check_in_time: DateTime.utc_now(),
        status: "checked_in"
      })

      {:ok, person} = Persons.create_person(attrs)
      
      assert person.status == "checked_in"
      assert person.room_id == room.id
      assert person.check_in_time != nil
      assert person.name == @valid_person_attrs.name
    end

    test "successfully creates person with check-in data for room with fob when fob provided", %{room_with_fob: room} do
      attrs = Map.merge(@valid_person_attrs, %{
        room_id: room.id,
        check_in_time: DateTime.utc_now(),
        status: "checked_in",
        fob: "FOB123"
      })

      {:ok, person} = Persons.create_person(attrs)
      
      assert person.status == "checked_in"
      assert person.room_id == room.id
      assert person.check_in_time != nil
      assert person.fob == "FOB123"
    end

    test "fails to create person with check-in data for room with fob when fob not provided", %{room_with_fob: room} do
      attrs = Map.merge(@valid_person_attrs, %{
        room_id: room.id,
        check_in_time: DateTime.utc_now(),
        status: "checked_in"
      })

      {:error, changeset} = Persons.create_person(attrs)
      
      refute changeset.valid?
      assert changeset.errors[:fob] == {"is required for this room", []}
    end

    test "fails to create person with checked_in status but no room_id" do
      attrs = Map.merge(@valid_person_attrs, %{
        check_in_time: DateTime.utc_now(),
        status: "checked_in"
      })

      {:error, changeset} = Persons.create_person(attrs)
      
      refute changeset.valid?
      assert changeset.errors[:room_id] == {"is required when checking in", [validation: :required]}
    end

    test "fails to create person with checked_in status but no check_in_time", %{room_no_fob: room} do
      attrs = Map.merge(@valid_person_attrs, %{
        room_id: room.id,
        status: "checked_in"
      })

      {:error, changeset} = Persons.create_person(attrs)
      
      refute changeset.valid?
      assert changeset.errors[:check_in_time] == {"is required when checking in", [validation: :required]}
    end

    test "successfully creates person with checked_out status (default behavior)" do
      {:ok, person} = Persons.create_person(@valid_person_attrs)
      
      assert person.status == "checked_out"
      assert person.room_id == nil
      assert person.check_in_time == nil
    end
  end
end