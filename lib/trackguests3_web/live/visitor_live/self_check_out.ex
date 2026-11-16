defmodule Trackguests3Web.VisitorLive.SelfCheckOut do
  @moduledoc """
  Phone self-service check-out, reached from a property's check-out QR code.

  Shows only the visits saved on this phone (signed cookie, see
  `Trackguests3Web.SelfService`) for the scanned property, never the list
  of other guests.
  """
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation
  alias Trackguests3.Persons

  @impl true
  def mount(%{"code" => code}, session, socket) do
    residence = Accomodation.get_residence_by_self_service_code!(code)
    visit_ids = session["self_service_visit_ids"] || []

    {:ok,
     socket
     |> assign(:page_title, gettext("Guest Check-Out"))
     |> assign(:residence, residence)
     |> assign(:visit_ids, visit_ids)
     |> assign(:checked_out, [])
     |> load_visits()}
  end

  @impl true
  def handle_event("check_out", %{"id" => id}, socket) do
    %{visit_ids: ids, residence: residence} = socket.assigns

    case Persons.self_check_out(id, ids, residence.id) do
      {:ok, person} ->
        Phoenix.PubSub.broadcast(Trackguests3.PubSub, "dashboard_updates", {:dashboard_update, %{}})

        {:noreply,
         socket
         |> update(:checked_out, &[person.name | &1])
         |> load_visits()}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, gettext("We couldn't check you out. Please see the front desk."))
         |> load_visits()}
    end
  end

  defp load_visits(socket) do
    %{visit_ids: ids, residence: residence} = socket.assigns
    assign(socket, :visits, Persons.list_self_service_visits(ids, residence.id))
  end

  defp format_check_in(person, residence) do
    time = Accomodation.format_datetime_in_timezone(person.check_in_time, residence.timezone)
    date = Accomodation.format_date_in_timezone(person.check_in_time, residence.timezone)
    "#{date}, #{time}"
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} guest_mode>
      <div class="max-w-md mx-auto space-y-6">
        <div class="text-center">
          <h1 class="text-3xl font-bold text-platinum">{gettext("Guest Check-Out")}</h1>
          <p class="mt-2 text-gray-600">{@residence.title}</p>
        </div>

        <div :for={name <- @checked_out} class="card-luxury text-center" role="status">
          <.icon name="hero-check-circle" class="size-10 text-green-600" />
          <p class="mt-2 text-lg font-semibold text-gray-900">
            {gettext("%{name} is checked out.", name: name)}
          </p>
          <p class="text-sm text-gray-600">{gettext("Thank you for visiting!")}</p>
        </div>

        <div :for={visit <- @visits} id={"visit-#{visit.id}"} class="card-luxury">
          <p class="text-xl font-semibold text-gray-900">{visit.name}</p>
          <dl class="mt-3 space-y-1 text-sm text-gray-600">
            <div :if={visit.room} class="flex gap-2">
              <dt class="font-medium">{gettext("Visiting:")}</dt>
              <dd>{visit.room.title}</dd>
            </div>
            <div class="flex gap-2">
              <dt class="font-medium">{gettext("Checked in:")}</dt>
              <dd>{format_check_in(visit, @residence)}</dd>
            </div>
          </dl>
          <button
            type="button"
            phx-click="check_out"
            phx-value-id={visit.id}
            phx-disable-with={gettext("Checking out...")}
            class="btn-primary w-full mt-6 justify-center"
          >
            {gettext("Check out now")}
          </button>
        </div>

        <div :if={@visits == [] and @checked_out == []} id="no-visit" class="card-luxury text-center">
          <.icon name="hero-device-phone-mobile" class="size-10 text-gray-400" />
          <p class="mt-2 text-lg font-semibold text-gray-900">
            {gettext("We couldn't find your visit on this phone.")}
          </p>
          <p class="mt-1 text-sm text-gray-600">
            {gettext("If you checked in at the front desk or on another device, please see the front desk to check out.")}
          </p>
          <.link navigate={~p"/p/#{@residence.self_service_code}/check-in"} class="btn-luxury mt-6 inline-flex">
            {gettext("Check in instead")}
          </.link>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
