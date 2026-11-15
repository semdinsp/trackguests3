defmodule Trackguests3Web.PropertyLive.PropertyAssignmentTest do
  @moduledoc """
  Joining an existing property grants access to its guest data, so only
  admins may assign users to properties.
  """
  use Trackguests3Web.ConnCase

  import Phoenix.LiveViewTest
  import Trackguests3.AccomodationFixtures
  import Trackguests3.AccountsFixtures

  alias Trackguests3.Accounts

  setup do
    %{target: residence_fixture(%{title: "Target Tower", address: "9 Private Road"})}
  end

  describe "non-admin users" do
    setup %{conn: conn} do
      user = user_fixture()
      %{conn: log_in_user(conn, user), user: user}
    end

    test "property select page does not list existing properties", %{conn: conn, target: target} do
      {:ok, _live, html} = live(conn, ~p"/property/select")

      refute html =~ target.title
      refute html =~ target.address
      assert html =~ "Ask an administrator"
    end

    test "cannot join a property from the select page", %{conn: conn, user: user, target: target} do
      {:ok, live, _html} = live(conn, ~p"/property/select")

      render_click(live, "select_property", %{"residence_id" => target.id})

      assert is_nil(Accounts.get_user!(user.id).property_id)
    end

    test "cannot join a property from the property dashboard", %{conn: conn, user: user, target: target} do
      {:ok, live, _html} = live(conn, ~p"/property")

      render_click(live, "select_property", %{"residence_id" => target.id})

      assert is_nil(Accounts.get_user!(user.id).property_id)
    end

    test "cannot join a property from settings", %{conn: conn, user: user, target: target} do
      {:ok, live, html} = live(conn, ~p"/users/settings")

      refute html =~ target.title

      render_submit(live, "update_property", %{"user" => %{"property_id" => target.id}})

      assert is_nil(Accounts.get_user!(user.id).property_id)
    end

    test "can still create a property of their own", %{conn: conn, user: user} do
      {:ok, live, _html} = live(conn, ~p"/property/new")

      live
      |> form("#property-form", residence: %{title: "My Own Place", address: "1 Own St", floor_count: 2})
      |> render_submit()

      user = Accounts.get_user_with_property!(user.id)
      assert user.property.title == "My Own Place"
    end
  end

  describe "admins" do
    test "can assign a user to a property from the admin user form", %{conn: conn, target: target} do
      {:ok, admin} = Accounts.update_user_admin(user_fixture(), %{admin: true})
      user = user_fixture()

      {:ok, live, _html} = live(log_in_user(conn, admin), ~p"/admin/users/#{user.id}/edit")

      live
      |> form("#user-form", user: %{property_id: target.id})
      |> render_submit()

      assert Accounts.get_user!(user.id).property_id == target.id
    end
  end
end
