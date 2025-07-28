defmodule Trackguests3Web.RoomsLiveTest do
  use Trackguests3Web.ConnCase

  import Phoenix.LiveViewTest
  import Trackguests3.AccomodationFixtures
  import Trackguests3.AccountsFixtures

  @create_attrs %{floor: 42, title: "some title", needs_fob: true, memo: "some memo", accepts_guests: true}
  @update_attrs %{floor: 43, title: "some updated title", needs_fob: false, memo: "some updated memo", accepts_guests: false}
  @invalid_attrs %{floor: nil, title: nil, needs_fob: false, memo: nil, accepts_guests: false}
  defp create_rooms(_) do
    residence = residence_fixture()
    rooms = rooms_fixture(%{residence_id: residence.id})
    user = user_fixture()
    {:ok, admin_user} = Trackguests3.Accounts.update_user_admin(user, %{admin: true})
    %{rooms: rooms, user: admin_user, residence: residence}
  end

  describe "Index" do
    setup [:create_rooms]

    test "lists all rooms", %{conn: conn, rooms: rooms, user: user} do
      conn = log_in_user(conn, user)
      {:ok, _index_live, html} = live(conn, ~p"/rooms")

      assert html =~ "All Rooms"
      assert html =~ rooms.title
    end

    test "saves new rooms", %{conn: conn, user: user, residence: residence} do
      conn = log_in_user(conn, user)
      {:ok, index_live, _html} = live(conn, ~p"/rooms")

      assert {:error, {:redirect, %{to: "/rooms/new"}}} =
               index_live
               |> element("a", "Add Room")
               |> render_click()
      
      {:ok, form_live, _} = live(conn, ~p"/rooms/new")

      assert render(form_live) =~ "New Room"

      assert form_live
             |> form("#rooms-form", rooms: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      # Include residence_id in create attrs
      create_attrs_with_residence = Map.put(@create_attrs, :residence_id, residence.id)
      
      assert {:ok, index_live, _html} =
               form_live
               |> form("#rooms-form", rooms: create_attrs_with_residence)
               |> render_submit()
               |> follow_redirect(conn, ~p"/rooms")

      html = render(index_live)
      assert html =~ "Room created successfully"
      assert html =~ "some title"
    end

    test "updates rooms in listing", %{conn: conn, rooms: rooms, user: user} do
      conn = log_in_user(conn, user)
      {:ok, index_live, _html} = live(conn, ~p"/rooms")

      # SCOTT FIX  was rooms- changed to rooms_collection
      assert {:error, {:redirect, %{to: "/rooms/" <> _}}} =
               index_live
               |> element("#rooms_collection-#{rooms.id} a", "Edit")
               |> render_click()
      
      {:ok, form_live, _} = live(conn, ~p"/rooms/#{rooms}/edit")

      assert render(form_live) =~ "Edit Room"

      assert form_live
             |> form("#rooms-form", rooms: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#rooms-form", rooms: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/rooms")

      html = render(index_live)
      assert html =~ "Room updated successfully"
      assert html =~ "some updated title"
    end

    # scott changed select to #rooms_collection-#{rooms.id} a
   test "deletes rooms in listing", %{conn: conn, rooms: rooms, user: user} do
      conn = log_in_user(conn, user)
      {:ok, index_live, _html} = live(conn, ~p"/rooms")

     assert index_live |> element("#rooms_collection-#{rooms.id} button", "Delete") |> render_click()
     refute has_element?(index_live, "#rooms_collection-#{rooms.id}")
    end
  end

  describe "Property-based Access Control" do
    test "admin user can see all rooms from different properties" do
      # Create admin user
      user = user_fixture()
      {:ok, admin_user} = Trackguests3.Accounts.update_user_admin(user, %{admin: true})
      
      # Create two different properties
      property1 = residence_fixture(%{title: "Property One"})
      property2 = residence_fixture(%{title: "Property Two"})
      
      # Create rooms in each property
      room1 = rooms_fixture(%{title: "Room in Property 1", residence_id: property1.id})
      room2 = rooms_fixture(%{title: "Room in Property 2", residence_id: property2.id})
      
      # Admin user should see both rooms
      conn = log_in_user(build_conn(), admin_user)
      {:ok, _index_live, html} = live(conn, ~p"/rooms")
      
      assert html =~ "All Rooms"
      assert html =~ room1.title
      assert html =~ room2.title
      assert html =~ property1.title
      assert html =~ property2.title
    end
    
    test "normal user only sees rooms from their assigned property" do
      # Create normal user (admin defaults to false)
      normal_user = user_fixture()
      
      # Create two different properties
      user_property = residence_fixture(%{title: "User Property"})
      other_property = residence_fixture(%{title: "Other Property"})
      
      # Assign user to their property
      {:ok, updated_user} = Trackguests3.Accounts.update_user_property(normal_user, %{property_id: user_property.id})
      
      # Create rooms in each property
      user_room = rooms_fixture(%{title: "User Room", residence_id: user_property.id})
      other_room = rooms_fixture(%{title: "Other Room", residence_id: other_property.id})
      
      # Normal user should only see room from their property
      conn = log_in_user(build_conn(), updated_user)
      {:ok, _index_live, html} = live(conn, ~p"/rooms")
      
      assert html =~ "All Rooms"
      assert html =~ user_room.title
      assert html =~ user_property.title
      refute html =~ other_room.title
      refute html =~ other_property.title
    end
    
    test "normal user with no assigned property sees no rooms" do
      # Create normal user with no property assignment (property_id defaults to nil)
      normal_user = user_fixture()
      
      # Create property and room
      property = residence_fixture(%{title: "Some Property"})
      room = rooms_fixture(%{title: "Some Room", residence_id: property.id})
      
      # User should see no rooms
      conn = log_in_user(build_conn(), normal_user)
      {:ok, _index_live, html} = live(conn, ~p"/rooms")
      
      assert html =~ "All Rooms"
      assert html =~ "No rooms created yet"
      refute html =~ room.title
      refute html =~ property.title
    end
  end

  describe "Show" do
    setup [:create_rooms]

    test "displays rooms", %{conn: conn, rooms: rooms, user: user} do
      conn = log_in_user(conn, user)
      {:ok, _show_live, html} = live(conn, ~p"/rooms/#{rooms}")

      assert html =~ "Rooms"
      assert html =~ rooms.title
    end

    test "updates rooms and returns to show", %{conn: conn, rooms: rooms, user: user} do
      conn = log_in_user(conn, user)
      {:ok, show_live, _html} = live(conn, ~p"/rooms/#{rooms}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/rooms/#{rooms}/edit?return_to=show")

      assert render(form_live) =~ "Edit Room"

      assert form_live
             |> form("#rooms-form", rooms: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#rooms-form", rooms: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/rooms/#{rooms}")

      html = render(show_live)
      assert html =~ "Room updated successfully"
      assert html =~ "some updated title"
    end
  end
end
