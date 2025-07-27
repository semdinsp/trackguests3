defmodule Trackguests3Web.AdminLive.Rooms do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :rooms, Accomodation.list_rooms())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Rooms")
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case Accomodation.get_room(id) do  
      {:ok, room} ->
        {:ok, _} = Accomodation.delete_rooms(room)
        {:noreply, stream_delete(socket, :rooms, room)}
      {:error, _} ->
        {:noreply, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Trackguests3Web.Layouts.admin flash={@flash} current_scope={@current_scope}>
      <.header>
        Rooms
        <:subtitle>Manage room properties</:subtitle>
      </.header>

      <.table
        id="rooms"
        rows={@streams.rooms}
      >
        <:col :let={{_id, room}} label="Title"><%= room.title %></:col>
        <:col :let={{_id, room}} label="Floor"><%= room.floor %></:col>
        <:col :let={{_id, room}} label="Needs Fob">
          <span class={"inline-flex px-2 py-1 text-xs font-semibold rounded-full " <> 
            if room.needs_fob, do: "bg-yellow-100 text-yellow-800", else: "bg-gray-100 text-gray-800"}>
            <%= if room.needs_fob, do: "Yes", else: "No" %>
          </span>
        </:col>
        <:col :let={{_id, room}} label="Accepts Guests">
          <span class={"inline-flex px-2 py-1 text-xs font-semibold rounded-full " <> 
            if room.accepts_guests, do: "bg-green-100 text-green-800", else: "bg-gray-100 text-gray-800"}>
            <%= if room.accepts_guests, do: "Yes", else: "No" %>
          </span>
        </:col>
        <:col :let={{_id, room}} label="Residence">
          <%= if room.residence, do: room.residence.title, else: "N/A" %>
        </:col>
        <:action :let={{_id, room}}>
          <.button
            phx-click={JS.push("delete", value: %{id: room.id}) |> hide("##{room.id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.button>
        </:action>
      </.table>
    </Trackguests3Web.Layouts.admin>
    """
  end
end