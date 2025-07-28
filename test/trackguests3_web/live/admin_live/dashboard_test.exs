defmodule Trackguests3Web.AdminLive.DashboardTest do
  use Trackguests3Web.ConnCase, async: false

  import Phoenix.LiveViewTest
  import Trackguests3.AccountsFixtures

  describe "Admin Dashboard (requires admin access)" do
    setup do
      user = user_fixture()
      {:ok, admin_user} = Trackguests3.Accounts.update_user_admin(user, %{admin: true})
      %{user: admin_user}
    end

    test "admin can access dashboard", %{conn: conn, user: admin_user} do
      conn = log_in_user(conn, admin_user)
      {:ok, _dashboard_live, html} = live(conn, ~p"/admin")

      assert html =~ "Admin Dashboard"
      assert html =~ "Manage all aspects of your TrackGuests application"
    end

    test "dashboard shows admin navigation cards", %{conn: conn, user: admin_user} do
      conn = log_in_user(conn, admin_user)
      {:ok, _dashboard_live, html} = live(conn, ~p"/admin")

      # Check all admin cards are present
      assert html =~ "Users"
      assert html =~ "Residences"
      assert html =~ "Rooms"
      assert html =~ "Persons"

      # Check navigation links
      assert html =~ "href=\"/admin/users\""
      assert html =~ "href=\"/admin/residences\""
      assert html =~ "href=\"/admin/rooms\""
      assert html =~ "href=\"/admin/persons\""
    end

    test "dashboard links are clickable", %{conn: conn, user: admin_user} do
      conn = log_in_user(conn, admin_user)
      {:ok, dashboard_live, _html} = live(conn, ~p"/admin")

      # Test navigation to different admin sections
      assert dashboard_live |> element("a[href='/admin/users']") |> has_element?()
      assert dashboard_live |> element("a[href='/admin/residences']") |> has_element?()
      assert dashboard_live |> element("a[href='/admin/rooms']") |> has_element?()
      assert dashboard_live |> element("a[href='/admin/persons']") |> has_element?()
    end
  end

  describe "Non-admin user access" do
    test "non-admin user cannot access dashboard", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      
      # Should redirect to home with error flash
      {:error, {:redirect, %{to: "/", flash: %{"error" => "You must be an admin to access this page."}}}} = 
        live(conn, ~p"/admin")
    end

    test "unauthenticated user cannot access dashboard", %{conn: conn} do
      # Should redirect to login
      {:error, {:redirect, %{to: "/users/log-in"}}} = live(conn, ~p"/admin")
    end
  end
end