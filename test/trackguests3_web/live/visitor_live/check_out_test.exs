defmodule Trackguests3Web.VisitorLive.CheckOutTest do
  use Trackguests3Web.ConnCase

  import Phoenix.LiveViewTest
  import Trackguests3.AccountsFixtures
  import Trackguests3.PersonsFixtures
  import Trackguests3.AccomodationFixtures

  alias Trackguests3.Persons

  describe "CheckOut LiveView authentication" do
    test "redirects unauthenticated users to login page", %{conn: conn} do
      # Try to access checkout page without authentication
      assert {:error, redirect} = live(conn, ~p"/visitor/check-out")
      
      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/users/log-in"
      assert %{"error" => "You must log in to access this page."} = flash
    end
  end

  describe "CheckOut LiveView" do
    test "shows only checked-in guests from user's property", %{conn: conn} do
      # Create two users with different properties
      user1 = user_fixture()
      _user2 = user_fixture()
      
      # Create two residences
      residence1 = residence_fixture(%{title: "Property A"})
      residence2 = residence_fixture(%{title: "Property B"})
      
      # Set user1's property to residence1
      {:ok, _user1} = Trackguests3.Accounts.update_user_property(user1, %{property_id: residence1.id})
      
      # Create rooms in each residence
      room1 = rooms_fixture(%{residence_id: residence1.id, title: "Room A1"})
      room2 = rooms_fixture(%{residence_id: residence2.id, title: "Room B1"})
      
      # Create checked-in guests in both properties
      _guest1 = person_fixture(%{
        name: "Guest in Property A",
        room_id: room1.id,
        status: "checked_in",
        check_in_time: DateTime.utc_now()
      })
      
      _guest2 = person_fixture(%{
        name: "Guest in Property B", 
        room_id: room2.id,
        status: "checked_in",
        check_in_time: DateTime.utc_now()
      })
      
      # Also create a checked-out guest in property A to ensure it's not shown
      _guest3 = person_fixture(%{
        name: "Checked-out Guest",
        room_id: room1.id,
        status: "checked_out",
        check_in_time: DateTime.utc_now(),
        check_out_time: DateTime.utc_now()
      })
      
      # Login as user1 and visit checkout page
      conn = log_in_user(conn, user1)
      {:ok, _lv, html} = live(conn, ~p"/visitor/check-out")
      
      # Should see guest from user1's property only
      assert html =~ "Guest in Property A"
      refute html =~ "Guest in Property B"
      refute html =~ "Checked-out Guest"
    end

    test "shows all checked-in guests when user has no property", %{conn: conn} do
      # Create user without property
      user = user_fixture()
      
      # Create residences and rooms
      residence1 = residence_fixture(%{title: "Property A"})
      residence2 = residence_fixture(%{title: "Property B"})
      room1 = rooms_fixture(%{residence_id: residence1.id, title: "Room A1"})
      room2 = rooms_fixture(%{residence_id: residence2.id, title: "Room B1"})
      
      # Create checked-in guests in both properties
      _guest1 = person_fixture(%{
        name: "Guest in Property A",
        room_id: room1.id,
        status: "checked_in",
        check_in_time: DateTime.utc_now()
      })
      
      _guest2 = person_fixture(%{
        name: "Guest in Property B",
        room_id: room2.id,
        status: "checked_in", 
        check_in_time: DateTime.utc_now()
      })
      
      # Login as user without property
      conn = log_in_user(conn, user)
      {:ok, _lv, html} = live(conn, ~p"/visitor/check-out")
      
      # Should see guests from all properties
      assert html =~ "Guest in Property A"
      assert html =~ "Guest in Property B"
    end


    test "checkout functionality still works with property filtering", %{conn: conn} do
      # Create user with property
      user = user_fixture()
      residence = residence_fixture(%{title: "Test Property"})
      {:ok, _user} = Trackguests3.Accounts.update_user_property(user, %{property_id: residence.id})
      
      # Create room and guest
      room = rooms_fixture(%{residence_id: residence.id, title: "Test Room"})
      guest = person_fixture(%{
        name: "Test Guest",
        room_id: room.id,
        status: "checked_in",
        check_in_time: DateTime.utc_now()
      })
      
      # Login and visit checkout page
      conn = log_in_user(conn, user)
      {:ok, lv, html} = live(conn, ~p"/visitor/check-out")
      
      # Verify guest is shown
      assert html =~ "Test Guest"
      
      # Check out the guest
      lv |> element(~s{button[phx-value-person-id="#{guest.id}"]}) |> render_click()
      
      # Verify guest is no longer shown
      html = render(lv)
      refute html =~ "Test Guest"
      assert html =~ "No Active Visitors"
      
      # Verify guest is actually checked out in database
      updated_guest = Persons.get_person!(guest.id)
      assert updated_guest.status == "checked_out"
      assert updated_guest.check_out_time != nil
    end
  end
end