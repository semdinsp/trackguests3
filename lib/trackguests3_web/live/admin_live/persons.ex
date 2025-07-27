defmodule Trackguests3Web.AdminLive.Persons do
  use Trackguests3Web, :live_view

  alias Trackguests3.Persons

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :persons, Persons.list_persons())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Persons")
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = Persons.get_person!(id)
    {:ok, _} = Persons.delete_person(person)

    {:noreply, stream_delete(socket, :persons, person)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Trackguests3Web.Layouts.admin flash={@flash} current_scope={@current_scope}>
      <.header>
        Persons
        <:subtitle>Manage visitor and staff records</:subtitle>
      </.header>

      <.table
        id="persons"
        rows={@streams.persons}
      >
        <:col :let={{_id, person}} label="Name"><%= person.name %></:col>
        <:col :let={{_id, person}} label="Email"><%= person.email %></:col>
        <:col :let={{_id, person}} label="Phone"><%= person.phone %></:col>
        <:col :let={{_id, person}} label="Company"><%= person.company %></:col>
        <:col :let={{_id, person}} label="Type">
          <span class={"inline-flex px-2 py-1 text-xs font-semibold rounded-full " <> 
            case person.visitor_type do
              "visitor" -> "bg-blue-100 text-blue-800"
              "staff" -> "bg-green-100 text-green-800"
              "resident" -> "bg-purple-100 text-purple-800"
              _ -> "bg-gray-100 text-gray-800"
            end}>
            <%= String.capitalize(person.visitor_type || "unknown") %>
          </span>
        </:col>
        <:col :let={{_id, person}} label="Status">
          <span class={"inline-flex px-2 py-1 text-xs font-semibold rounded-full " <> 
            if person.status == "checked_in", do: "bg-green-100 text-green-800", else: "bg-gray-100 text-gray-800"}>
            <%= String.replace(person.status || "unknown", "_", " ") |> String.capitalize() %>
          </span>
        </:col>
        <:action :let={{_id, person}}>
          <.button
            phx-click={JS.push("delete", value: %{id: person.id}) |> hide("##{person.id}")}
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