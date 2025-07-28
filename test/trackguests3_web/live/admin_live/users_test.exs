defmodule Trackguests3Web.AdminLive.UsersTest do
  use Trackguests3Web.ConnCase, async: false

  import Phoenix.LiveViewTest
  import Trackguests3.AccountsFixtures

  describe "Admin Users Management (requires admin access)" do
    setup do
      admin_user = user_fixture()
      {:ok, admin_user} = Trackguests3.Accounts.update_user_admin(admin_user, %{admin: true})
      
      regular_user = user_fixture()
      
      %{admin_user: admin_user, regular_user: regular_user}
    end

    test "admin can access users index", %{conn: conn, admin_user: admin_user} do
      conn = log_in_user(conn, admin_user)
      {:ok, _users_live, html} = live(conn, ~p"/admin/users")

      assert html =~ "Users"
      assert html =~ "Manage user accounts and admin privileges"
    end

    test "admin can see list of users", %{conn: conn, admin_user: admin_user, regular_user: regular_user} do
      conn = log_in_user(conn, admin_user)
      {:ok, _users_live, html} = live(conn, ~p"/admin/users")

      # Should show both admin and regular users
      assert html =~ admin_user.email
      assert html =~ regular_user.email
      
      # Should show admin status
      assert html =~ "Admin"
      assert html =~ "User"
    end

    test "admin can view user edit form", %{conn: conn, admin_user: admin_user, regular_user: regular_user} do
      conn = log_in_user(conn, admin_user)
      {:ok, _users_live, _html} = live(conn, ~p"/admin/users/#{regular_user.id}/edit")

      # Should show user edit modal
      assert {:ok, _edit_live, html} = live(conn, ~p"/admin/users/#{regular_user.id}/edit")
      assert html =~ "Edit User"
      assert html =~ regular_user.email
    end

    test "admin can toggle admin status of users", %{conn: conn, admin_user: admin_user, regular_user: regular_user} do
      conn = log_in_user(conn, admin_user)
      {:ok, users_live, _html} = live(conn, ~p"/admin/users")

      # Initially regular user should not be admin
      refute regular_user.admin

      # Toggle to admin using the specific button for this user
      users_live
      |> element("button[phx-value-id='#{regular_user.id}']", "Make Admin")
      |> render_click()

      # Check user was updated in database
      updated_user = Trackguests3.Accounts.get_user!(regular_user.id)
      assert updated_user.admin

      # Toggle back to regular user
      users_live
      |> element("button[phx-value-id='#{regular_user.id}']", "Remove Admin")
      |> render_click()

      # Check user was updated in database
      updated_user = Trackguests3.Accounts.get_user!(regular_user.id)
      refute updated_user.admin
    end

    test "admin can navigate to user edit page", %{conn: conn, admin_user: admin_user, regular_user: regular_user} do
      conn = log_in_user(conn, admin_user)
      {:ok, users_live, _html} = live(conn, ~p"/admin/users/#{regular_user.id}/edit")

      assert has_element?(users_live, "#user-modal")
      html = render(users_live)
      assert html =~ "Edit User"
    end

    test "users table shows user information correctly", %{conn: conn, admin_user: admin_user, regular_user: regular_user} do
      conn = log_in_user(conn, admin_user)
      {:ok, _users_live, html} = live(conn, ~p"/admin/users")

      # Check email column
      assert html =~ admin_user.email
      assert html =~ regular_user.email

      # Check admin status badges
      assert html =~ "bg-green-100 text-green-800"  # Admin badge styling
      assert html =~ "bg-gray-100 text-gray-800"     # User badge styling

      # Check confirmed status (users from fixtures should be confirmed)
      assert html =~ "Yes"  # Confirmed status

      # Check date formatting
      assert html =~ ~r/\d{4}-\d{2}-\d{2}/  # Date format YYYY-MM-DD
    end
  end

  describe "Non-admin user access" do
    test "non-admin user cannot access users management", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      
      # Should redirect to home with error flash
      {:error, {:redirect, %{to: "/", flash: %{"error" => "You must be an admin to access this page."}}}} = 
        live(conn, ~p"/admin/users")
    end

    test "unauthenticated user cannot access users management", %{conn: conn} do
      # Should redirect to login
      {:error, {:redirect, %{to: "/users/log-in"}}} = live(conn, ~p"/admin/users")
    end

    test "non-admin user cannot access user edit page", %{conn: conn} do
      user = user_fixture()
      other_user = user_fixture()
      conn = log_in_user(conn, user)
      
      # Should redirect to home with error flash
      {:error, {:redirect, %{to: "/", flash: %{"error" => "You must be an admin to access this page."}}}} = 
        live(conn, ~p"/admin/users/#{other_user.id}/edit")
    end
  end
end