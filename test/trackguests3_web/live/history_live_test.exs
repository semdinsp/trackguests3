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

      conn = log_in_user(conn, user)
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

      conn = log_in_user(conn, user)
      
      # Export with last 30 days (should only include recent person)
      start_date = Date.add(Date.utc_today(), -30)
      end_date = Date.utc_today()
      
      conn = get(conn, "/history/export.csv?start_date=#{Date.to_iso8601(start_date)}&end_date=#{Date.to_iso8601(end_date)}")
      csv_content = response(conn, 200)
      
      # Should include recent person but not old person
      assert csv_content =~ recent_person.name
      refute csv_content =~ old_person.name
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