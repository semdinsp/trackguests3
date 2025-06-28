defmodule Trackguests3Web.DashboardLive do
  use Trackguests3Web, :live_view

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
    stats = Accomodation.get_dashboard_stats()
    residences_with_stats = Accomodation.list_residences_with_stats()

    socket
    |> assign(:stats, stats)
    |> assign(:residences_with_stats, residences_with_stats)
    |> assign(:page_title, "Property Dashboard")
  end
end
