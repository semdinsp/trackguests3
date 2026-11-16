defmodule Trackguests3Web.SelfServiceController do
  @moduledoc """
  Remembers a phone check-in. LiveViews can't set cookies, so after a
  self-service check-in the LiveView redirects here with a short-lived
  signed token; we add the visit to the phone's signed cookie and send the
  guest to their check-out page.
  """
  use Trackguests3Web, :controller

  alias Trackguests3.Accomodation
  alias Trackguests3Web.SelfService

  def checked_in(conn, %{"code" => code} = params) do
    residence = Accomodation.get_residence_by_self_service_code!(code)

    case SelfService.verify_handoff(params["t"] || "") do
      {:ok, person_id} ->
        ids = conn |> SelfService.visit_ids() |> SelfService.add_visit(person_id)

        conn
        |> put_resp_cookie(SelfService.cookie_name(), ids, SelfService.cookie_opts())
        |> put_flash(:info, gettext("You're checked in. Scan the check-out code when you leave."))
        |> redirect(to: ~p"/p/#{residence.self_service_code}/check-out")

      {:error, _} ->
        conn
        |> put_flash(:error, gettext("That link has expired. Please see the front desk."))
        |> redirect(to: ~p"/p/#{residence.self_service_code}/check-out")
    end
  end
end
