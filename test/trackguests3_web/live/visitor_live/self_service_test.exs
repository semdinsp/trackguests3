defmodule Trackguests3Web.VisitorLive.SelfServiceTest do
  @moduledoc """
  Phone self-service check-in/out via per-property QR codes. Guests never log
  in, so these tests focus on property isolation: a code only works for its
  own property and a phone only ever sees the visits it checked in.
  """
  use Trackguests3Web.ConnCase

  import Phoenix.LiveViewTest
  import Trackguests3.AccomodationFixtures
  import Trackguests3.AccountsFixtures

  alias Trackguests3.{Accomodation, Accounts, Persons}
  alias Trackguests3Web.SelfService

  setup do
    home = residence_fixture(%{title: "Harbour House"})
    other = residence_fixture(%{title: "Secret Tower"})

    %{
      home: home,
      other: other,
      home_room: rooms_fixture(%{residence_id: home.id, title: "Lobby 101", needs_fob: false}),
      other_room: rooms_fixture(%{residence_id: other.id, title: "Tower 9", needs_fob: false})
    }
  end

  defp guest(room, name) do
    {:ok, person} =
      Persons.create_person(%{
        name: name,
        visitor_type: "visitor",
        status: "checked_in",
        room_id: room.id,
        check_in_time: DateTime.utc_now()
      })

    person
  end

  # Checks a guest in on the "phone" and follows the cookie handoff,
  # returning a conn that carries the phone's visit cookie.
  defp phone_check_in(conn, residence, room, name) do
    {:ok, lv, _html} = live(conn, ~p"/p/#{residence.self_service_code}/check-in")
    render_click(lv, "select_room", %{"room_id" => room.id, "room_display" => room.title})

    {:error, {:redirect, %{to: handoff}}} =
      lv |> element("#check-in-form") |> render_submit(%{person: %{name: name}})

    assert handoff =~ "/p/#{residence.self_service_code}/checked-in?t="

    conn = get(conn, handoff)
    assert redirected_to(conn) == ~p"/p/#{residence.self_service_code}/check-out"
    recycle(conn)
  end

  describe "property codes" do
    test "every property gets a unique code that can be replaced", %{home: home, other: other} do
      assert is_binary(home.self_service_code)
      assert home.self_service_code != other.self_service_code

      {:ok, rotated} = Accomodation.rotate_self_service_code(home)
      assert rotated.self_service_code != home.self_service_code

      assert_raise Ecto.NoResultsError, fn ->
        Accomodation.get_residence_by_self_service_code!(home.self_service_code)
      end
    end

    test "unknown codes are a 404", %{conn: conn} do
      assert_raise Ecto.NoResultsError, fn -> live(conn, ~p"/p/not-a-code/check-in") end
      assert_raise Ecto.NoResultsError, fn -> live(conn, ~p"/p/not-a-code/check-out") end
    end
  end

  describe "phone check-in" do
    test "is locked to the scanned property", %{conn: conn, home: home} do
      {:ok, _lv, html} = live(conn, ~p"/p/#{home.self_service_code}/check-in")

      assert html =~ "Harbour House"
      refute html =~ "Secret Tower"
      refute html =~ ~s(id="residence-select")
      refute html =~ "self-service-qr"
      refute html =~ "View History"
      refute html =~ ~s(id="quick-actions")
    end

    test "rejects a room from another property", %{conn: conn, home: home, other_room: other_room} do
      {:ok, lv, _html} = live(conn, ~p"/p/#{home.self_service_code}/check-in")

      html =
        lv
        |> element("#check-in-form")
        |> render_submit(%{person: %{name: "Sneaky", room_id: other_room.id}})

      assert html =~ "Please select a room"
      assert Persons.list_persons() == []
    end

    test "then shows only that guest's own visit on check-out", %{conn: conn, home: home, home_room: room} do
      guest(room, "Someone Else")

      conn = phone_check_in(conn, home, room, "Ada Lovelace")
      {:ok, _lv, html} = live(conn, ~p"/p/#{home.self_service_code}/check-out")

      assert html =~ "Ada Lovelace"
      assert html =~ "Lobby 101"
      refute html =~ "Someone Else"
    end
  end

  describe "phone check-out" do
    test "checks the guest out", %{conn: conn, home: home, home_room: room} do
      conn = phone_check_in(conn, home, room, "Ada Lovelace")
      {:ok, lv, _html} = live(conn, ~p"/p/#{home.self_service_code}/check-out")
      [visit] = Persons.list_persons()

      html = lv |> element("#visit-#{visit.id} button") |> render_click()

      assert html =~ "Ada Lovelace is checked out."
      assert Persons.get_person!(visit.id).status == "checked_out"
    end

    test "without a saved visit tells the guest to see the front desk", %{conn: conn, home: home, home_room: room} do
      guest(room, "Someone Else")
      {:ok, _lv, html} = live(conn, ~p"/p/#{home.self_service_code}/check-out")

      assert html =~ "find your visit on this phone"
      refute html =~ "Someone Else"
    end

    test "cannot check out a visit that isn't saved on this phone", %{conn: conn, home: home, home_room: room} do
      stranger = guest(room, "Someone Else")
      conn = phone_check_in(conn, home, room, "Ada Lovelace")
      {:ok, lv, _html} = live(conn, ~p"/p/#{home.self_service_code}/check-out")

      render_click(lv, "check_out", %{"id" => stranger.id})

      assert Persons.get_person!(stranger.id).status == "checked_in"
    end

    test "a visit saved for one property doesn't show on another property's code",
         %{conn: conn, home: home, other: other, home_room: room} do
      conn = phone_check_in(conn, home, room, "Ada Lovelace")
      {:ok, lv, html} = live(conn, ~p"/p/#{other.self_service_code}/check-out")
      [visit] = Persons.list_persons()

      refute html =~ "Ada Lovelace"
      render_click(lv, "check_out", %{"id" => visit.id})
      assert Persons.get_person!(visit.id).status == "checked_in"
    end

    test "an expired or forged handoff link doesn't save a visit", %{conn: conn, home: home, home_room: room} do
      visit = guest(room, "Someone Else")
      forged = Phoenix.Token.sign(Trackguests3Web.Endpoint, "wrong salt", visit.id)

      conn = get(conn, ~p"/p/#{home.self_service_code}/checked-in?#{[t: forged]}")
      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "expired"

      {:ok, _lv, html} = live(recycle(conn), ~p"/p/#{home.self_service_code}/check-out")
      refute html =~ "Someone Else"
    end
  end

  describe "QR codes on the lobby check-in page" do
    test "are shown to staff of the property", %{conn: conn, home: home} do
      {:ok, user} = Accounts.update_user_property(user_fixture(), %{property_id: home.id})
      {:ok, lv, _html} = live(log_in_user(conn, user), ~p"/visitor/check-in?residence_id=#{home.id}")

      assert has_element?(lv, "#self-service-qr svg")
      assert has_element?(lv, "#self-service-qr", "Scan to check in")
      assert has_element?(lv, "#self-service-qr", "Scan to check out")
    end

    test "are not shown to anonymous visitors", %{conn: conn, home: home} do
      {:ok, lv, _html} = live(conn, ~p"/visitor/check-in?residence_id=#{home.id}")
      refute has_element?(lv, "#self-service-qr")
    end

    test "are not shown for another property", %{conn: conn, home: home, other: other} do
      {:ok, user} = Accounts.update_user_property(user_fixture(), %{property_id: home.id})
      {:ok, lv, _html} = live(log_in_user(conn, user), ~p"/visitor/check-in?residence_id=#{other.id}")

      refute has_element?(lv, "#self-service-qr")
    end
  end

  describe "printable QR page" do
    test "shows both codes and can replace them", %{conn: conn, home: home} do
      {:ok, user} = Accounts.update_user_property(user_fixture(), %{property_id: home.id})
      {:ok, lv, _html} = live(log_in_user(conn, user), ~p"/property/qr-codes")

      assert has_element?(lv, "#qr-check-in svg")
      assert has_element?(lv, "#qr-check-out svg")

      render_click(lv, "rotate")

      refute Accomodation.get_residence!(home.id).self_service_code == home.self_service_code
    end

    test "does not show another property's codes", %{conn: conn, home: home, other: other} do
      {:ok, user} = Accounts.update_user_property(user_fixture(), %{property_id: home.id})
      {:ok, _lv, html} = live(log_in_user(conn, user), ~p"/property/qr-codes?residence_id=#{other.id}")

      refute html =~ "Secret Tower"
      refute html =~ other.self_service_code
    end
  end

  test "the visit list is capped and newest first" do
    ids = Enum.reduce(1..12, [], fn n, acc -> SelfService.add_visit(acc, "id-#{n}") end)
    assert length(ids) == 10
    assert hd(ids) == "id-12"
  end
end
