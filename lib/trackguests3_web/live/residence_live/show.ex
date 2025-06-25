defmodule Trackguests3Web.ResidenceLive.Show do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Residence {@residence.id}
        <:subtitle>This is a residence record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/residences"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/residences/#{@residence}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit residence
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@residence.title}</:item>
        <:item title="Address">{@residence.address}</:item>
        <:item title="Floor count">{@residence.floor_count}</:item>
        <:item title="Logo">{@residence.logo}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Residence")
     |> assign(:residence, Accomodation.get_residence!(id))}
  end
end
