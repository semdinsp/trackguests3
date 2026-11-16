defmodule Trackguests3Web.VisitorLive.CheckOutUsabilityTest do
  use Trackguests3Web.ConnCase

  import Phoenix.LiveViewTest
  import Trackguests3.AccomodationFixtures
  import Trackguests3.AccountsFixtures

  alias Trackguests3.Persons

  defp guest(room, name, check_in_time \\ DateTime.utc_now()) do
    {:ok, person} =
      Persons.create_person(%{
        name: name,
        email: "#{String.downcase(String.replace(name, " ", "."))}@example.com",
        visitor_type: "visitor",
        status: "checked_in",
        fob: "F-1",
        room_id: room.id,
        check_in_time: check_in_time
      })

    person
  end

  setup %{conn: conn} do
    own = residence_fixture()
    other = residence_fixture()
    own_room = rooms_fixture(%{residence_id: own.id})
    other_room = rooms_fixture(%{residence_id: other.id})
    {:ok, user} = Trackguests3.Accounts.update_user_property(user_fixture(), %{property_id: own.id})

    %{conn: log_in_user(conn, user), own_room: own_room, other_room: other_room}
  end

  test "cannot check out a guest from another property", %{conn: conn, other_room: other_room} do
    outsider = guest(other_room, "Outside Guest")
    {:ok, lv, _html} = live(conn, ~p"/visitor/check-out")

    render_click(lv, "check_out", %{"person-id" => outsider.id})

    assert Persons.get_person!(outsider.id).status == "checked_in"
  end

  test "asks for confirmation before checking a guest out", %{conn: conn, own_room: room} do
    guest(room, "Ada Lovelace")
    {:ok, _lv, html} = live(conn, ~p"/visitor/check-out")

    assert html =~ "Check out Ada Lovelace?"
  end

  test "filters a long visitor list by name", %{conn: conn, own_room: room} do
    for name <- ["Ada Lovelace", "Grace Hopper", "Alan Turing", "Edsger Dijkstra"], do: guest(room, name)
    {:ok, lv, _html} = live(conn, ~p"/visitor/check-out")

    html = lv |> form("#visitor-filter", q: "grace") |> render_change()

    assert html =~ "Grace Hopper"
    refute html =~ "Alan Turing"

    html = lv |> form("#visitor-filter", q: "nobody") |> render_change()
    assert html =~ "No visitors match"
  end

  test "shows the check-in date under the time", %{conn: conn, own_room: room} do
    guest(room, "Ada Lovelace")
    {:ok, lv, _html} = live(conn, ~p"/visitor/check-out")

    assert has_element?(lv, ".check-in-date[data-overdue=false]")
    refute render(lv) =~ "days ago"
  end

  test "flags guests checked in on an earlier day", %{conn: conn, own_room: room} do
    guest(room, "Grace Hopper", DateTime.add(DateTime.utc_now(), -3 * 86_400, :second))
    {:ok, lv, _html} = live(conn, ~p"/visitor/check-out")

    assert has_element?(lv, ".check-in-date[data-overdue]", "3 days ago")
  end
end
