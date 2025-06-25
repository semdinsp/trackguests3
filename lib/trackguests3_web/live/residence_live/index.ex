defmodule Trackguests3Web.ResidenceLive.Index do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Residences
        <:actions>
          <.button variant="primary" navigate={~p"/residences/new"}>
            <.icon name="hero-plus" /> New Residence
          </.button>
        </:actions>
      </.header>

      <.table
        id="residences"
        rows={@streams.residences}
        row_click={fn {_id, residence} -> JS.navigate(~p"/residences/#{residence}") end}
      >
        <:col :let={{_id, residence}} label="Title">{residence.title}</:col>
        <:col :let={{_id, residence}} label="Address">{residence.address}</:col>
        <:col :let={{_id, residence}} label="Floor count">{residence.floor_count}</:col>
        <:col :let={{_id, residence}} label="Logo">{residence.logo}</:col>
        <:action :let={{_id, residence}}>
          <div class="sr-only">
            <.link navigate={~p"/residences/#{residence}"}>Show</.link>
          </div>
          <.link navigate={~p"/residences/#{residence}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, residence}}>
          <.link
            phx-click={JS.push("delete", value: %{id: residence.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Residences")
     |> stream(:residences, Accomodation.list_residences())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    residence = Accomodation.get_residence!(id)
    {:ok, _} = Accomodation.delete_residence(residence)

    {:noreply, stream_delete(socket, :residences, residence)}
  end
end
