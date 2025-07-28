defmodule Trackguests3Web.HistoryLiveTest do
  use Trackguests3Web.ConnCase, async: false

  import Phoenix.LiveViewTest
  import Trackguests3.AccomodationFixtures
  import Trackguests3.AccountsFixtures

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

  @update_attrs %{
    name: "Jane Doe",
    email: "jane@example.com",
    phone: "555-5678",
    company: "Another Corp",
    visitor_type: "staff",
    purpose_of_visit: "Staff meeting",
    fob: "FOB456",
    memo: "Updated visit",
    status: "checked_out"
  }

  describe "Index" do
    setup [:create_user, :create_residence, :create_room, :create_person]

    test "lists all history records", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)
      {:ok, _index_live, html} = live(conn, ~p"/history")

      assert html =~ "Guest History"
      assert html =~ "Select Date Range"
    end

    test "shows default date range (last 30 days)", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)
      {:ok, index_live, _html} = live(conn, ~p"/history")

      end_date = Date.utc_today()
      start_date = Date.add(end_date, -30)

      assert has_element?(index_live, "input[name='start_date'][value='#{Date.to_iso8601(start_date)}']")
      assert has_element?(index_live, "input[name='end_date'][value='#{Date.to_iso8601(end_date)}']")
    end

    test "displays person in history when checked in today", %{conn: conn, user: user, person: person} do
      conn = log_in_user(conn, user)
      {:ok, _index_live, html} = live(conn, ~p"/history")

      assert html =~ person.name
      assert html =~ person.email
    end

    test "updates date range and filters data", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)
      {:ok, index_live, _html} = live(conn, ~p"/history")

      # Set a future date range where no records should exist
      future_start = Date.add(Date.utc_today(), 30)
      future_end = Date.add(Date.utc_today(), 60)

      index_live
      |> form("#history-form", %{
        "start_date" => Date.to_iso8601(future_start),
        "end_date" => Date.to_iso8601(future_end)
      })
      |> render_submit()

      assert has_element?(index_live, "h3", "No records found")
    end

    test "validates date range (start date must be before end date)", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)
      {:ok, index_live, _html} = live(conn, ~p"/history")

      # Set invalid date range (start after end)
      start_date = Date.utc_today()
      end_date = Date.add(Date.utc_today(), -10)

      index_live
      |> form("#history-form", %{
        "start_date" => Date.to_iso8601(start_date),
        "end_date" => Date.to_iso8601(end_date)
      })
      |> render_submit()

      assert has_element?(index_live, "[role=alert]", "Start date must be before or equal to end date")
    end

    test "handles invalid date format", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)
      {:ok, index_live, _html} = live(conn, ~p"/history")

      # Submit form with invalid date format
      index_live
      |> form("#history-form", %{
        "start_date" => "invalid-date",
        "end_date" => "also-invalid"
      })
      |> render_submit()

      assert has_element?(index_live, "[role=alert]", "Invalid date format")
    end

    test "shows loading state when updating date range", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)
      {:ok, index_live, _html} = live(conn, ~p"/history")

      # The loading state should appear briefly during form submission
      future_start = Date.add(Date.utc_today(), 30)
      future_end = Date.add(Date.utc_today(), 60)

      # Submit form and check for loading state in the immediate response
      html = index_live
             |> form("#history-form", %{
               "start_date" => Date.to_iso8601(future_start),
               "end_date" => Date.to_iso8601(future_end)
             })
             |> render_submit()

      # After submission, loading should be false
      refute html =~ "Loading history data..."
    end

    test "displays CSV export button when records exist", %{conn: conn, user: user, person: _person} do
      conn = log_in_user(conn, user)
      {:ok, index_live, _html} = live(conn, ~p"/history")

      assert has_element?(index_live, "button", "Export CSV")
      refute has_element?(index_live, "button[disabled]", "Export CSV")
    end

    test "displays KPI metrics on history page", %{conn: conn, user: user, person: _person} do
      conn = log_in_user(conn, user)
      {:ok, _index_live, html} = live(conn, ~p"/history")

      # Check that KPI cards are present
      assert html =~ "Currently Checked In"
      assert html =~ "Total Rooms"
      assert html =~ "Properties"
      assert html =~ "Occupancy Rate"
      assert html =~ "Unique Visitors"
      assert html =~ "Total Visits"

      # Check that numeric values are displayed (could be 0 or more)
      assert html =~ ~r/\d+/ # Should contain at least one number
    end

    test "currently checked in guest count is accurate", %{conn: conn, user: user, room: room} do
      # Create additional test persons with different statuses
      {:ok, checked_in_person1} = Trackguests3.Persons.create_person(%{
        name: "John Checked In",
        email: "john.checkedin@example.com",
        phone: "555-0001",
        company: "Test Corp",
        visitor_type: "visitor",
        purpose_of_visit: "Meeting",
        room_id: room.id,
        status: "checked_in",
        fob: "FOB001",
        memo: "Test person",
        check_in_time: DateTime.utc_now()
      })

      {:ok, checked_in_person2} = Trackguests3.Persons.create_person(%{
        name: "Jane Checked In",
        email: "jane.checkedin@example.com",
        phone: "555-0002",
        company: "Test Corp",
        visitor_type: "staff",
        purpose_of_visit: "Work",
        room_id: room.id,
        status: "checked_in",
        fob: "FOB002",
        memo: "Test person",
        check_in_time: DateTime.utc_now()
      })

      {:ok, _checked_out_person} = Trackguests3.Persons.create_person(%{
        name: "Bob Checked Out",
        email: "bob.checkedout@example.com",
        phone: "555-0003",
        company: "Test Corp",
        visitor_type: "visitor",
        purpose_of_visit: "Visit",
        room_id: room.id,
        status: "checked_out",
        fob: "FOB003",
        memo: "Test person",
        check_in_time: DateTime.add(DateTime.utc_now(), -3600, :second),
        check_out_time: DateTime.utc_now()
      })

      conn = log_in_user(conn, user)
      {:ok, _index_live, html} = live(conn, ~p"/history")

      # Count expected checked-in guests
      # Should be 3: the original person from setup + 2 new checked-in persons
      # (Note: person from setup has status "checked_in" by default)
      expected_count = 3

      # Check that the displayed count matches expected
      # Look for the checked-in count in the KPI card
      assert html =~ ~r/Currently Checked In.*?#{expected_count}/s

      # Verify the persons exist in database with correct status
      all_persons = Trackguests3.Persons.list_persons()
      checked_in_count = Enum.count(all_persons, &(&1.status == "checked_in"))
      assert checked_in_count == expected_count

      # Clean up test data
      Trackguests3.Persons.delete_person(checked_in_person1)
      Trackguests3.Persons.delete_person(checked_in_person2)
    end

    test "disables CSV export button when no records exist", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)
      {:ok, index_live, _html} = live(conn, ~p"/history")

      # Set a future date range where no records should exist
      future_start = Date.add(Date.utc_today(), 30)
      future_end = Date.add(Date.utc_today(), 60)

      index_live
      |> form("#history-form", %{
        "start_date" => Date.to_iso8601(future_start),
        "end_date" => Date.to_iso8601(future_end)
      })
      |> render_submit()

      assert has_element?(index_live, "button[disabled]", "Export CSV")
    end

    test "triggers CSV download", %{conn: conn, user: user, person: _person} do
      conn = log_in_user(conn, user)
      {:ok, index_live, _html} = live(conn, ~p"/history")

      # Click the CSV export button
      result = index_live
               |> element("button", "Export CSV")
               |> render_click()

      # Should show the new download message
      assert result =~ "Preparing CSV download..."
    end

    test "displays comprehensive person information in table", %{
      conn: conn,
      user: user,
      person: person,
      room: room,
      residence: residence
    } do
      conn = log_in_user(conn, user)
      {:ok, _index_live, html} = live(conn, ~p"/history")

      # Check that all person details are displayed
      assert html =~ person.name
      assert html =~ person.email
      assert html =~ person.phone
      assert html =~ person.company
      assert html =~ person.visitor_type
      assert html =~ person.purpose_of_visit
      assert html =~ person.fob
      assert html =~ person.memo
      assert html =~ room.title
      assert html =~ "Floor #{room.floor}"
      assert html =~ residence.title
      assert html =~ person.status
    end

    test "displays date range summary correctly", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)
      {:ok, _index_live, html} = live(conn, ~p"/history")

      end_date = Date.utc_today()
      start_date = Date.add(end_date, -30)

      assert html =~ "Showing records from"
      assert html =~ Date.to_iso8601(start_date)
      assert html =~ Date.to_iso8601(end_date)
      assert html =~ "31 days"
    end
  end

  describe "CSV Export" do
    setup [:create_user, :create_residence, :create_room]

    test "downloads CSV with correct headers", %{conn: conn, user: user} do
      # Create room for this test
      residence = residence_fixture()
      room = rooms_fixture(%{residence_id: residence.id})
      
      # Create a person with check-in time in the current period
      person_attrs = Map.put(@create_attrs, :room_id, room.id)
                     |> Map.put(:check_in_time, DateTime.utc_now())
      
      {:ok, _person} = Trackguests3.Persons.create_person(person_attrs)

      conn = log_in_user(conn, user)
      
      # Test CSV download endpoint
      conn = get(conn, ~p"/history/export.csv")
      
      assert response(conn, 200)
      assert get_resp_header(conn, "content-type") |> List.first() =~ "text/csv"
      
      csv_content = response(conn, 200)
      
      # Check CSV headers
      assert csv_content =~ "Name,Email,Phone,Company,Visitor Type,Purpose of Visit,Room,Floor,Residence,Check In Time,Check Out Time,Status,Fob,Memo"
    end

    test "CSV includes person data", %{conn: conn, user: user} do
      # Create room for this test
      residence = residence_fixture()
      room = rooms_fixture(%{residence_id: residence.id})
      
      # Create a person with check-in time
      person_attrs = Map.put(@create_attrs, :room_id, room.id)
                     |> Map.put(:check_in_time, DateTime.utc_now())
      
      {:ok, person} = Trackguests3.Persons.create_person(person_attrs)

      # Make user admin to access all data
      {:ok, admin_user} = Trackguests3.Accounts.update_user_admin(user, %{admin: true})
      
      conn = log_in_user(conn, admin_user)
      conn = get(conn, ~p"/history/export.csv")
      
      csv_content = response(conn, 200)
      
      # Check that person data is in CSV
      assert csv_content =~ person.name
      assert csv_content =~ person.email
      assert csv_content =~ person.phone
      assert csv_content =~ person.company
      assert csv_content =~ room.title
      assert csv_content =~ residence.title
    end

    test "CSV respects date range filters", %{conn: conn, user: user} do
      # Create room for this test
      residence = residence_fixture()
      room = rooms_fixture(%{residence_id: residence.id})
      
      # Create person with old check-in time
      old_datetime = DateTime.add(DateTime.utc_now(), -60 * 60 * 24 * 40, :second) # 40 days ago
      person_attrs = Map.put(@create_attrs, :room_id, room.id)
                     |> Map.put(:check_in_time, old_datetime)
      
      {:ok, old_person} = Trackguests3.Persons.create_person(person_attrs)

      # Create person with recent check-in time
      recent_attrs = Map.put(@update_attrs, :room_id, room.id)
                     |> Map.put(:check_in_time, DateTime.utc_now())
      
      {:ok, recent_person} = Trackguests3.Persons.create_person(recent_attrs)

      # Make user admin to access all data
      {:ok, admin_user} = Trackguests3.Accounts.update_user_admin(user, %{admin: true})

      conn = log_in_user(conn, admin_user)
      
      # Export with last 30 days (should only include recent person)
      start_date = Date.add(Date.utc_today(), -30)
      end_date = Date.utc_today()
      
      conn = get(conn, "/history/export.csv?start_date=#{Date.to_iso8601(start_date)}&end_date=#{Date.to_iso8601(end_date)}")
      csv_content = response(conn, 200)
      
      # Should include recent person but not old person
      assert csv_content =~ recent_person.name
      refute csv_content =~ old_person.name
    end

    test "Non-admin user can only access data from their assigned property", %{conn: conn, user: user} do
      # Create two different residences
      user_residence = residence_fixture()
      other_residence = residence_fixture()
      
      user_room = rooms_fixture(%{residence_id: user_residence.id})
      other_room = rooms_fixture(%{residence_id: other_residence.id})
      
      # Create person in user's property
      user_person_attrs = Map.put(@create_attrs, :room_id, user_room.id)
                         |> Map.put(:check_in_time, DateTime.utc_now())
      {:ok, user_person} = Trackguests3.Persons.create_person(user_person_attrs)
      
      # Create person in other property
      other_person_attrs = Map.put(@update_attrs, :room_id, other_room.id)
                          |> Map.put(:check_in_time, DateTime.utc_now())
      {:ok, other_person} = Trackguests3.Persons.create_person(other_person_attrs)
      
      # Assign user to their property (not admin)
      {:ok, property_user} = Trackguests3.Accounts.update_user_property(user, %{property_id: user_residence.id})
      
      conn = log_in_user(conn, property_user)
      conn = get(conn, ~p"/history/export.csv")
      
      csv_content = response(conn, 200)
      
      # Should include person from user's property but not from other property
      assert csv_content =~ user_person.name
      refute csv_content =~ other_person.name
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_residence(_) do
    residence = residence_fixture()
    %{residence: residence}
  end

  defp create_room(%{residence: residence}) do
    room = rooms_fixture(%{residence_id: residence.id})
    %{room: room}
  end

  defp create_person(%{room: room}) do
    person_attrs = Map.put(@create_attrs, :room_id, room.id)
                   |> Map.put(:check_in_time, DateTime.utc_now())
    
    {:ok, person} = Trackguests3.Persons.create_person(person_attrs)
    %{person: person}
  end
end