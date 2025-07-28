defmodule Trackguests3Web.AdminLive.PersonsTest do
  use Trackguests3Web.ConnCase, async: false

  import Phoenix.LiveViewTest
  import Trackguests3.AccountsFixtures
  import Trackguests3.AccomodationFixtures

  @create_attrs %{
    name: "John Doe",
    email: "john@example.com",
    phone: "555-1234",
    company: "Test Corp",
    visitor_type: "visitor",
    purpose_of_visit: "Business meeting",
    fob: "FOB123",
    memo: "Test visit",
    status: "checked_in"
  }

  describe "Admin Persons Management (requires admin access)" do
    setup do
      user = user_fixture()
      {:ok, admin_user} = Trackguests3.Accounts.update_user_admin(user, %{admin: true})
      
      residence = residence_fixture()
      room = rooms_fixture(%{residence_id: residence.id})
      
      person_attrs = Map.put(@create_attrs, :room_id, room.id)
                     |> Map.put(:check_in_time, DateTime.utc_now())
      
      {:ok, person} = Trackguests3.Persons.create_person(person_attrs)
      
      %{admin_user: admin_user, residence: residence, room: room, person: person}
    end

    test "admin can access persons index", %{conn: conn, admin_user: admin_user} do
      conn = log_in_user(conn, admin_user)
      {:ok, _persons_live, html} = live(conn, ~p"/admin/persons")

      assert html =~ "Persons"
      assert html =~ "Manage visitor and staff records"
    end

    test "admin can see list of persons", %{conn: conn, admin_user: admin_user, person: person} do
      conn = log_in_user(conn, admin_user)
      {:ok, _persons_live, html} = live(conn, ~p"/admin/persons")

      # Should show person details
      assert html =~ person.name
      assert html =~ person.email
      assert html =~ person.phone
      assert html =~ person.company
    end

    test "persons table shows person information correctly", %{conn: conn, admin_user: admin_user, person: person} do
      conn = log_in_user(conn, admin_user)
      {:ok, _persons_live, html} = live(conn, ~p"/admin/persons")

      # Check basic person info
      assert html =~ person.name
      assert html =~ person.email
      assert html =~ person.phone
      assert html =~ person.company

      # Check visitor type with proper styling
      case person.visitor_type do
        "visitor" -> 
          assert html =~ "bg-blue-100 text-blue-800"
          assert html =~ "Visitor"
        "staff" -> 
          assert html =~ "bg-green-100 text-green-800"
          assert html =~ "Staff"
        "resident" -> 
          assert html =~ "bg-purple-100 text-purple-800"
          assert html =~ "Resident"
      end

      # Check status with proper styling
      case person.status do
        "checked_in" -> 
          assert html =~ "bg-green-100 text-green-800"
          assert html =~ "Checked in"
        "checked_out" -> 
          assert html =~ "bg-gray-100 text-gray-800"
          assert html =~ "Checked out"
      end
    end

    test "admin can delete a person", %{conn: conn, admin_user: admin_user, person: person} do
      conn = log_in_user(conn, admin_user)
      {:ok, persons_live, html} = live(conn, ~p"/admin/persons")

      # Should show the person initially
      assert html =~ person.name

      # Delete the person
      persons_live |> element("button", "Delete") |> render_click()

      # Should no longer show the person
      html = render(persons_live)
      refute html =~ person.name

      # Verify person was deleted from database
      assert_raise Ecto.NoResultsError, fn ->
        Trackguests3.Persons.get_person!(person.id)
      end
    end

    test "handles different visitor types correctly", %{conn: conn, admin_user: admin_user, room: room} do
      # Create different types of persons
      visitor_types = ["visitor", "staff", "resident"]
      
      persons = Enum.map(visitor_types, fn type ->
        attrs = @create_attrs 
                |> Map.put(:visitor_type, type)
                |> Map.put(:room_id, room.id)
                |> Map.put(:name, "#{String.capitalize(type)} Person")
                |> Map.put(:email, "#{type}@example.com")
                |> Map.put(:check_in_time, DateTime.utc_now())
        
        {:ok, person} = Trackguests3.Persons.create_person(attrs)
        person
      end)

      conn = log_in_user(conn, admin_user)
      {:ok, _persons_live, html} = live(conn, ~p"/admin/persons")

      # Check that all visitor types are displayed with correct styling
      assert html =~ "bg-blue-100 text-blue-800"    # visitor
      assert html =~ "bg-green-100 text-green-800"  # staff  
      assert html =~ "bg-purple-100 text-purple-800" # resident

      # Check that all persons are shown
      Enum.each(persons, fn person ->
        assert html =~ person.name
        assert html =~ person.email
      end)
    end

    test "handles different statuses correctly", %{conn: conn, admin_user: admin_user, room: room} do
      # Create persons with different statuses
      statuses = ["checked_in", "checked_out"]
      
      Enum.each(statuses, fn status ->
        attrs = @create_attrs 
                |> Map.put(:status, status)
                |> Map.put(:room_id, room.id)
                |> Map.put(:name, "#{String.replace(status, "_", " ") |> String.capitalize()} Person")
                |> Map.put(:email, "#{status}@example.com")
                |> Map.put(:check_in_time, DateTime.utc_now())
        
        {:ok, _person} = Trackguests3.Persons.create_person(attrs)
      end)

      conn = log_in_user(conn, admin_user)
      {:ok, _persons_live, html} = live(conn, ~p"/admin/persons")

      # Check status badges
      assert html =~ "Checked in"
      assert html =~ "Checked out"
    end

    test "empty persons list is handled correctly", %{conn: conn, admin_user: admin_user} do
      # Delete all persons first
      persons = Trackguests3.Persons.list_persons()
      Enum.each(persons, &Trackguests3.Persons.delete_person/1)

      conn = log_in_user(conn, admin_user)
      {:ok, _persons_live, html} = live(conn, ~p"/admin/persons")

      # Should still show the header but no persons
      assert html =~ "Persons"
      assert html =~ "Manage visitor and staff records"
    end
  end

  describe "Non-admin user access" do
    test "non-admin user cannot access persons management", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      
      # Should redirect to home with error flash
      {:error, {:redirect, %{to: "/", flash: %{"error" => "You must be an admin to access this page."}}}} = 
        live(conn, ~p"/admin/persons")
    end

    test "unauthenticated user cannot access persons management", %{conn: conn} do
      # Should redirect to login
      {:error, {:redirect, %{to: "/users/log-in"}}} = live(conn, ~p"/admin/persons")
    end
  end
end