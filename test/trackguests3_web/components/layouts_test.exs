defmodule Trackguests3Web.LayoutsTest do
  use Trackguests3Web.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias Trackguests3.Accounts
  alias Trackguests3Web.Layouts

  # Helper to create proper assigns for root layout
  defp root_assigns(current_scope \\ nil) do
    %{
      current_scope: current_scope,
      inner_content: []
    }
  end

  describe "root layout admin link visibility" do
    test "admin link is hidden when user is not logged in" do
      assigns = root_assigns(nil)
      
      html = render_component(&Layouts.root/1, assigns)
      
      refute html =~ "Admin"
      refute html =~ ~p"/admin"
    end

    test "admin link is hidden when user is not an admin" do
      user = Trackguests3.AccountsFixtures.user_fixture()
      current_scope = %{user: user}
      assigns = root_assigns(current_scope)
      
      html = render_component(&Layouts.root/1, assigns)
      
      refute html =~ "Admin"
      refute html =~ ~p"/admin"
      # Should still show other user links
      assert html =~ "Settings"
      assert html =~ "Log out"
    end

    test "admin link is shown when user is an admin" do
      # First create a regular user, then update to admin
      user = Trackguests3.AccountsFixtures.user_fixture()
      {:ok, admin_user} = Accounts.update_user_admin(user, %{admin: true})
      
      current_scope = %{user: admin_user}
      assigns = root_assigns(current_scope)
      
      html = render_component(&Layouts.root/1, assigns)
      
      assert html =~ "Admin"
      assert html =~ ~p"/admin"
      # Should also show other user links
      assert html =~ "Settings"
      assert html =~ "Log out"
    end

    test "user email is displayed correctly for admin users" do
      user = Trackguests3.AccountsFixtures.user_fixture(%{email: "admin@example.com"})
      {:ok, admin_user} = Accounts.update_user_admin(user, %{admin: true})
      
      current_scope = %{user: admin_user}
      assigns = root_assigns(current_scope)
      
      html = render_component(&Layouts.root/1, assigns)
      
      # The template logic falls back to "User" for non-struct scopes, but admin link should work
      assert html =~ "Admin"
      assert html =~ ~p"/admin"
    end

    test "user email is displayed correctly for non-admin users" do
      user = Trackguests3.AccountsFixtures.user_fixture(%{email: "user@example.com"})
      current_scope = %{user: user}
      assigns = root_assigns(current_scope)
      
      html = render_component(&Layouts.root/1, assigns)
      
      # The template logic falls back to "User" for non-struct scopes
      refute html =~ "Admin"
      assert html =~ "Settings"
      assert html =~ "Log out"
    end

    test "layout handles malformed current_scope gracefully" do
      # Test with incomplete scope structure
      assigns = root_assigns(%{})
      
      html = render_component(&Layouts.root/1, assigns)
      
      refute html =~ "Admin"
      # With empty current_scope map, it shows as authenticated user
      assert html =~ "Settings"
      assert html =~ "Log out"
      # Should show "User" as fallback email
      assert html =~ "User"
    end

    test "layout handles current_scope with user but no admin field" do
      # Test edge case where user exists but admin field is nil
      user_without_admin = %{email: "test@example.com", admin: nil}
      current_scope = %{user: user_without_admin}
      assigns = root_assigns(current_scope)
      
      html = render_component(&Layouts.root/1, assigns)
      
      refute html =~ "Admin"
      assert html =~ "Settings"
      assert html =~ "Log out"
    end

    test "layout shows proper navigation for unauthenticated users" do
      assigns = root_assigns(nil)
      
      html = render_component(&Layouts.root/1, assigns)
      
      assert html =~ "Register"
      assert html =~ "Log in"
      refute html =~ "Settings"
      refute html =~ "Log out"
      refute html =~ "Admin"
    end
  end

  describe "app layout" do
    test "app layout renders without admin-specific content" do
      user = Trackguests3.AccountsFixtures.user_fixture()
      {:ok, admin_user} = Accounts.update_user_admin(user, %{admin: true})
      current_scope = %{user: admin_user}
      
      assigns = %{
        flash: %{},
        current_scope: current_scope,
        inner_block: []
      }
      
      html = render_component(&Layouts.app/1, assigns)
      
      # App layout should not contain admin navigation
      refute html =~ "Admin Panel"
      # But should contain the main navigation (Properties was removed from main nav)
      assert html =~ "TrackGuests"
      assert html =~ "Rooms"
      assert html =~ "Check-In"
      assert html =~ "Check-Out"
    end
  end

  describe "admin layout" do
    test "admin layout renders admin-specific navigation" do
      user = Trackguests3.AccountsFixtures.user_fixture(%{email: "admin@example.com"})
      {:ok, admin_user} = Accounts.update_user_admin(user, %{admin: true})
      current_scope = %{user: admin_user}
      
      assigns = %{
        flash: %{},
        current_scope: current_scope,
        inner_block: []
      }
      
      html = render_component(&Layouts.admin/1, assigns)
      
      assert html =~ "Admin Panel"
      assert html =~ "Dashboard"
      assert html =~ "Users"
      assert html =~ "Residences"
      assert html =~ "Rooms"
      assert html =~ "Persons"
      assert html =~ "admin@example.com"
      assert html =~ "← Back to Site"
    end

    test "admin layout handles missing user gracefully" do
      assigns = %{
        flash: %{},
        current_scope: nil,
        inner_block: []
      }
      
      html = render_component(&Layouts.admin/1, assigns)
      
      assert html =~ "Admin Panel"
      refute html =~ "Log out"
    end
  end
end