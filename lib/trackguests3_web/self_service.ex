defmodule Trackguests3Web.SelfService do
  @moduledoc """
  Phone self-service check-in and check-out via per-property QR codes.

  Each property has a secret `self_service_code`. Its QR codes point to
  `/p/:code/check-in` and `/p/:code/check-out`, which need no login.

  After a guest checks in on their phone, the visit's id is stored in a
  signed cookie on that phone. The check-out page only shows visits listed
  in that cookie, so guests never see anyone else's details.
  """

  @cookie "tg_visits"
  @max_visits 10
  @cookie_max_age 60 * 60 * 24 * 30
  @handoff_salt "self-service visit handoff"
  @handoff_max_age 300

  def cookie_name, do: @cookie

  @doc "Cookie options; the value is signed so it can't be forged or edited."
  def cookie_opts,
    do: [sign: true, max_age: @cookie_max_age, http_only: true, same_site: "Lax"]

  @doc "Short-lived token that lets the handoff controller set the visit cookie."
  def sign_handoff(person_id),
    do: Phoenix.Token.sign(Trackguests3Web.Endpoint, @handoff_salt, person_id)

  def verify_handoff(token),
    do: Phoenix.Token.verify(Trackguests3Web.Endpoint, @handoff_salt, token, max_age: @handoff_max_age)

  @doc "Adds a visit id to the phone's list, newest first, capped."
  def add_visit(visit_ids, person_id) do
    [person_id | List.wrap(visit_ids) |> Enum.reject(&(&1 == person_id))]
    |> Enum.take(@max_visits)
  end

  @doc "Reads the phone's visit ids from the signed cookie."
  def visit_ids(%Plug.Conn{} = conn) do
    conn = Plug.Conn.fetch_cookies(conn, signed: [@cookie])

    case conn.cookies[@cookie] do
      ids when is_list(ids) -> Enum.filter(ids, &is_binary/1)
      _ -> []
    end
  end

  @doc "live_session `:session` callback: exposes the visit ids to LiveViews."
  def live_session(conn), do: %{"self_service_visit_ids" => visit_ids(conn)}

  @doc "Inline SVG QR code for a URL."
  def qr_svg(url, width \\ 200) do
    url |> EQRCode.encode() |> EQRCode.svg(width: width, viewbox: true)
  end
end
