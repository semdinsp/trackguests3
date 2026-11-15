defmodule Trackguests3Web.DashboardLive do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accounts
  alias Trackguests3.Accomodation

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      # Subscribe to real-time updates
      Phoenix.PubSub.subscribe(Trackguests3.PubSub, "dashboard_updates")
    end

    {:ok, assign_dashboard_data(socket)}
  end

  @impl true
  def handle_info({:dashboard_update, _data}, socket) do
    {:noreply, assign_dashboard_data(socket)}
  end

  @impl true
  def handle_event("refresh_stats", _params, socket) do
    {:noreply, assign_dashboard_data(socket)}
  end

  defp assign_dashboard_data(socket) do
    # Anonymous visitors see no data; users see only their own property
    user = socket.assigns[:current_scope] && socket.assigns.current_scope.user
    filter = Accounts.residence_filter(user)

    stats = Accomodation.get_dashboard_stats(filter)
    residences_with_stats = Accomodation.list_residences_with_stats(filter)

    socket
    |> assign(:stats, stats)
    |> assign(:residences_with_stats, residences_with_stats)
    |> assign(:page_title, "Property Dashboard")
  end
end
