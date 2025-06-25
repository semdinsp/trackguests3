defmodule Trackguests3Web.RoomsLive.Index do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Rooms
        <:actions>
          <.button variant="primary" navigate={~p"/rooms/new"}>
            <.icon name="hero-plus" /> New Rooms
          </.button>
        </:actions>
      </.header>

      <.table
        id="rooms"
        rows={@streams.rooms_collection}
        row_click={fn {_id, rooms} -> JS.navigate(~p"/rooms/#{rooms}") end}
      >
        <:col :let={{_id, rooms}} label="Title">{rooms.title}</:col>
        <:col :let={{_id, rooms}} label="Floor">{rooms.floor}</:col>
        <:col :let={{_id, rooms}} label="Needs fob">{rooms.needs_fob}</:col>
        <:col :let={{_id, rooms}} label="Memo">{rooms.memo}</:col>
        <:col :let={{_id, rooms}} label="Accepts guests">{rooms.accepts_guests}</:col>
        <:action :let={{_id, rooms}}>
          <div class="sr-only">
            <.link navigate={~p"/rooms/#{rooms}"}>Show</.link>
          </div>
          <.link navigate={~p"/rooms/#{rooms}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, rooms}}>
          <.link
            phx-click={JS.push("delete", value: %{id: rooms.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Rooms")
     |> stream(:rooms_collection, Accomodation.list_rooms())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    rooms = Accomodation.get_rooms!(id)
    {:ok, _} = Accomodation.delete_rooms(rooms)

    {:noreply, stream_delete(socket, :rooms_collection, rooms)}
  end
end
