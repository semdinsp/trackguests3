defmodule Trackguests3Web.RoomsLive.Show do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Rooms {@rooms.id}
        <:subtitle>This is a rooms record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/rooms"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/rooms/#{@rooms}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit rooms
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@rooms.title}</:item>
        <:item title="Floor">{@rooms.floor}</:item>
        <:item title="Needs fob">{@rooms.needs_fob}</:item>
        <:item title="Memo">{@rooms.memo}</:item>
        <:item title="Accepts guests">{@rooms.accepts_guests}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Rooms")
     |> assign(:rooms, Accomodation.get_rooms!(id))}
  end
end
