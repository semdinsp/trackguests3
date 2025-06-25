defmodule Trackguests3Web.ResidenceLiveTest do
  use Trackguests3Web.ConnCase

  import Phoenix.LiveViewTest
  import Trackguests3.AccomodationFixtures

  @create_attrs %{address: "some address", title: "some title", logo: "some logo", floor_count: 42}
  @update_attrs %{address: "some updated address", title: "some updated title", logo: "some updated logo", floor_count: 43}
  @invalid_attrs %{address: nil, title: nil, logo: nil, floor_count: nil}
  defp create_residence(_) do
    residence = residence_fixture()

    %{residence: residence}
  end

  describe "Index" do
    setup [:create_residence]

    test "lists all residences", %{conn: conn, residence: residence} do
      {:ok, _index_live, html} = live(conn, ~p"/residences")

      assert html =~ "Listing Residences"
      assert html =~ residence.title
    end

    test "saves new residence", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/residences")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Residence")
               |> render_click()
               |> follow_redirect(conn, ~p"/residences/new")

      assert render(form_live) =~ "New Residence"

      assert form_live
             |> form("#residence-form", residence: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#residence-form", residence: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/residences")

      html = render(index_live)
      assert html =~ "Residence created successfully"
      assert html =~ "some title"
    end

    test "updates residence in listing", %{conn: conn, residence: residence} do
      {:ok, index_live, _html} = live(conn, ~p"/residences")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#residences-#{residence.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/residences/#{residence}/edit")

      assert render(form_live) =~ "Edit Residence"

      assert form_live
             |> form("#residence-form", residence: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#residence-form", residence: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/residences")

      html = render(index_live)
      assert html =~ "Residence updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes residence in listing", %{conn: conn, residence: residence} do
      {:ok, index_live, _html} = live(conn, ~p"/residences")

      assert index_live |> element("#residences-#{residence.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#residences-#{residence.id}")
    end
  end

  describe "Show" do
    setup [:create_residence]

    test "displays residence", %{conn: conn, residence: residence} do
      {:ok, _show_live, html} = live(conn, ~p"/residences/#{residence}")

      assert html =~ "Show Residence"
      assert html =~ residence.title
    end

    test "updates residence and returns to show", %{conn: conn, residence: residence} do
      {:ok, show_live, _html} = live(conn, ~p"/residences/#{residence}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/residences/#{residence}/edit?return_to=show")

      assert render(form_live) =~ "Edit Residence"

      assert form_live
             |> form("#residence-form", residence: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#residence-form", residence: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/residences/#{residence}")

      html = render(show_live)
      assert html =~ "Residence updated successfully"
      assert html =~ "some updated title"
    end
  end
end
