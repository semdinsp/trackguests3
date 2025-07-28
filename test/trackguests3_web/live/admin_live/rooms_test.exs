defmodule Trackguests3Web.AdminLive.RoomsTest do
  use Trackguests3Web.ConnCase, async: false

  import Phoenix.LiveViewTest
  import Trackguests3.AccountsFixtures
  import Trackguests3.AccomodationFixtures

  describe "Admin Rooms Management (requires admin access)" do
    setup do
      user = user_fixture()
      {:ok, admin_user} = Trackguests3.Accounts.update_user_admin(user, %{admin: true})
      
      residence = residence_fixture()
      room = rooms_fixture(%{residence_id: residence.id})
      
      %{admin_user: admin_user, residence: residence, room: room}
    end

    test "admin can access rooms index", %{conn: conn, admin_user: admin_user} do
      conn = log_in_user(conn, admin_user)
      {:ok, _rooms_live, html} = live(conn, ~p"/admin/rooms")

      assert html =~ "Rooms"
      assert html =~ "Manage room properties"
    end

    test "admin can see list of rooms", %{conn: conn, admin_user: admin_user, room: room, residence: residence} do
      conn = log_in_user(conn, admin_user)
      {:ok, _rooms_live, html} = live(conn, ~p"/admin/rooms")

      # Should show room details
      assert html =~ room.title
      assert html =~ "#{room.floor}"
      assert html =~ residence.title
    end

    test "rooms table shows room information correctly", %{conn: conn, admin_user: admin_user, room: room} do
      conn = log_in_user(conn, admin_user)
      {:ok, _rooms_live, html} = live(conn, ~p"/admin/rooms")

      # Check room title
      assert html =~ room.title

      # Check floor number
      assert html =~ "#{room.floor}"

      # Check needs_fob status with proper styling
      if room.needs_fob do
        assert html =~ "bg-yellow-100 text-yellow-800"
        assert html =~ "Yes"
      else
        assert html =~ "bg-gray-100 text-gray-800"
        assert html =~ "No"
      end

      # Check accepts_guests status with proper styling
      if room.accepts_guests do
        assert html =~ "bg-green-100 text-green-800"
      else
        assert html =~ "bg-gray-100 text-gray-800"
      end
    end

    test "admin can delete a room", %{conn: conn, admin_user: admin_user, room: room} do
      conn = log_in_user(conn, admin_user)
      {:ok, rooms_live, html} = live(conn, ~p"/admin/rooms")

      # Should show the room initially
      assert html =~ room.title

      # Delete the room
      rooms_live |> element("button", "Delete") |> render_click()

      # Should no longer show the room
      html = render(rooms_live)
      refute html =~ room.title

      # Verify room was deleted from database
      assert {:error, _} = Trackguests3.Accomodation.get_room(room.id)
    end

    test "rooms without residence are handled gracefully", %{conn: conn, admin_user: admin_user} do
      # Create a room without residence association for edge case testing
      {:ok, _orphaned_room} = Trackguests3.Accomodation.create_rooms(%{
        title: "Orphaned Room",
        floor: 99,
        needs_fob: false,
        accepts_guests: true,
        memo: "Test room"
      })

      conn = log_in_user(conn, admin_user)
      {:ok, _rooms_live, html} = live(conn, ~p"/admin/rooms")

      # Should show "N/A" for residence when no residence is associated
      assert html =~ "Orphaned Room"
      assert html =~ "N/A"
    end

    test "empty rooms list is handled correctly", %{conn: conn, admin_user: admin_user} do
      # Delete all rooms first
      rooms = Trackguests3.Accomodation.list_rooms()
      Enum.each(rooms, &Trackguests3.Accomodation.delete_rooms/1)

      conn = log_in_user(conn, admin_user)
      {:ok, _rooms_live, html} = live(conn, ~p"/admin/rooms")

      # Should still show the header but no rooms
      assert html =~ "Rooms"
      assert html =~ "Manage room properties"
    end
  end

  describe "Non-admin user access" do
    test "non-admin user cannot access rooms management", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      
      # Should redirect to home with error flash
      {:error, {:redirect, %{to: "/", flash: %{"error" => "You must be an admin to access this page."}}}} = 
        live(conn, ~p"/admin/rooms")
    end

    test "unauthenticated user cannot access rooms management", %{conn: conn} do
      # Should redirect to login
      {:error, {:redirect, %{to: "/users/log-in"}}} = live(conn, ~p"/admin/rooms")
    end
  end
end