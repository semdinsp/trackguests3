defmodule Trackguests3Web.PropertyLive.QrCodes do
  @moduledoc """
  Printable check-in / check-out QR codes for a property, and a way to
  replace them (old printed codes stop working).
  """
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation
  alias Trackguests3.Accounts
  alias Trackguests3Web.SelfService

  @impl true
  def mount(params, _session, socket) do
    user = Accounts.get_user_with_property!(socket.assigns.current_scope.user.id)

    residence =
      case params["residence_id"] do
        id when is_binary(id) and id != "" ->
          if Accounts.can_access_residence?(user, id), do: Accomodation.get_residence!(id)

        _ ->
          user.property
      end

    {:ok,
     socket
     |> assign(:page_title, gettext("Guest QR codes"))
     |> assign(:user, user)
     |> assign_residence(residence && Accomodation.ensure_self_service_code(residence))}
  end

  @impl true
  def handle_event("rotate", _params, socket) do
    %{residence: residence, user: user} = socket.assigns

    if residence && Accounts.can_access_residence?(user, residence.id) do
      {:ok, residence} = Accomodation.rotate_self_service_code(residence)

      {:noreply,
       socket
       |> assign_residence(residence)
       |> put_flash(:info, gettext("New QR codes created. Print them again; the old ones no longer work."))}
    else
      {:noreply, socket}
    end
  end

  defp assign_residence(socket, nil), do: assign(socket, residence: nil, codes: [])

  defp assign_residence(socket, residence) do
    code = residence.self_service_code

    codes = [
      %{id: "check-in", label: gettext("Scan to check in"), url: url(~p"/p/#{code}/check-in")},
      %{id: "check-out", label: gettext("Scan to check out"), url: url(~p"/p/#{code}/check-out")}
    ]

    assign(socket, residence: residence, codes: Enum.map(codes, &Map.put(&1, :svg, SelfService.qr_svg(&1.url, 280))))
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div id="qr-print" class="space-y-6">
        <div class="print:hidden">
          <h1 class="text-3xl font-bold text-platinum">{gettext("Guest QR codes")}</h1>
          <p class="mt-2 text-sm text-gray-600">
            {gettext("Guests scan these with their phone camera to check in and out without logging in. Each guest only ever sees their own visit.")}
          </p>
        </div>

        <div :if={!@residence} class="card-luxury">
          <p class="text-gray-700">{gettext("You need a property before you can create QR codes.")}</p>
          <.link navigate={~p"/property"} class="btn-luxury mt-4 inline-flex">{gettext("My Property")}</.link>
        </div>

        <div :if={@residence}>
          <p class="text-center text-2xl font-bold text-gray-900">{@residence.title}</p>
          <div class="mt-6 grid grid-cols-1 sm:grid-cols-2 gap-6">
            <figure :for={code <- @codes} id={"qr-#{code.id}"} class="card-luxury flex flex-col items-center text-center">
              <div class="qr-code w-full max-w-72 rounded-lg bg-white p-3">{Phoenix.HTML.raw(code.svg)}</div>
              <figcaption class="mt-4 text-xl font-semibold text-gray-900">{code.label}</figcaption>
            </figure>
          </div>

          <div class="mt-8 flex flex-col sm:flex-row gap-3 justify-center print:hidden">
            <button type="button" onclick="window.print()" class="btn-primary justify-center">
              <.icon name="hero-printer" class="size-5 mr-2" /> {gettext("Print")}
            </button>
            <button
              type="button"
              phx-click="rotate"
              data-confirm={gettext("Replace both QR codes? Printed copies of the old codes will stop working.")}
              class="btn-luxury justify-center"
            >
              <.icon name="hero-arrow-path" class="size-5 mr-2" /> {gettext("Replace codes")}
            </button>
          </div>
          <p class="mt-3 text-center text-xs text-gray-500 print:hidden">
            {gettext("Replace the codes if a photo of them is shared outside the building.")}
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
