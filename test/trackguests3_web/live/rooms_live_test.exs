defmodule Trackguests3Web.RoomsLiveTest do
  use Trackguests3Web.ConnCase

  import Phoenix.LiveViewTest
  import Trackguests3.AccomodationFixtures

  @create_attrs %{floor: 42, title: "some title", needs_fob: true, memo: "some memo", accepts_guests: true}
  @update_attrs %{floor: 43, title: "some updated title", needs_fob: false, memo: "some updated memo", accepts_guests: false}
  @invalid_attrs %{floor: nil, title: nil, needs_fob: false, memo: nil, accepts_guests: false}
  defp create_rooms(_) do
    _residence = residence_fixture()

    rooms = rooms_fixture()

    %{rooms: rooms}
  end

  describe "Index" do
    setup [:create_rooms]

    test "lists all rooms", %{conn: conn, rooms: rooms} do
      {:ok, _index_live, html} = live(conn, ~p"/rooms")

      assert html =~ "Listing Rooms"
      assert html =~ rooms.title
    end

    test "saves new rooms", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/rooms")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Rooms")
               |> render_click()
               |> follow_redirect(conn, ~p"/rooms/new")

      assert render(form_live) =~ "New Rooms"

      assert form_live
             |> form("#rooms-form", rooms: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#rooms-form", rooms: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/rooms")

      html = render(index_live)
      assert html =~ "Rooms created successfully"
      assert html =~ "some title"
    end

    test "updates rooms in listing", %{conn: conn, rooms: rooms} do
      {:ok, index_live, _html} = live(conn, ~p"/rooms")

      # SCOTT FIX  was rooms- changed to rooms_collection
      assert {:ok, form_live, _html} =
               index_live
               |> element("#rooms_collection-#{rooms.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/rooms/#{rooms}/edit")

      assert render(form_live) =~ "Edit Rooms"

      assert form_live
             |> form("#rooms-form", rooms: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#rooms-form", rooms: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/rooms")

      html = render(index_live)
      assert html =~ "Rooms updated successfully"
      assert html =~ "some updated title"
    end

    # scott changed select to #rooms_collection-#{rooms.id} a
   test "deletes rooms in listing", %{conn: conn, rooms: rooms} do
      {:ok, index_live, _html} = live(conn, ~p"/rooms")

     assert index_live |> element("#rooms_collection-#{rooms.id} a", "Delete") |> render_click()
     refute has_element?(index_live, "#rooms_collection-#{rooms.id}")
    end
  end

  describe "Show" do
    setup [:create_rooms]

    test "displays rooms", %{conn: conn, rooms: rooms} do
      {:ok, _show_live, html} = live(conn, ~p"/rooms/#{rooms}")

      assert html =~ "Show Rooms"
      assert html =~ rooms.title
    end

    test "updates rooms and returns to show", %{conn: conn, rooms: rooms} do
      {:ok, show_live, _html} = live(conn, ~p"/rooms/#{rooms}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/rooms/#{rooms}/edit?return_to=show")

      assert render(form_live) =~ "Edit Rooms"

      assert form_live
             |> form("#rooms-form", rooms: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#rooms-form", rooms: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/rooms/#{rooms}")

      html = render(show_live)
      assert html =~ "Rooms updated successfully"
      assert html =~ "some updated title"
    end
  end
end
