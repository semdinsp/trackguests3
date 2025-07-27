defmodule Trackguests3Web.AdminLive.Residences do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation
  alias Trackguests3.Accomodation.Residence

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :residences, Accomodation.list_residences())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Residence")
    |> assign(:residence, Accomodation.get_residence!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Residence")
    |> assign(:residence, %Residence{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Residences")
    |> assign(:residence, nil)
  end

  @impl true
  def handle_info({Trackguests3Web.AdminLive.ResidenceFormComponent, {:saved, residence}}, socket) do
    {:noreply, stream_insert(socket, :residences, residence)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    residence = Accomodation.get_residence!(id)
    {:ok, _} = Accomodation.delete_residence(residence)

    {:noreply, stream_delete(socket, :residences, residence)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Trackguests3Web.Layouts.admin flash={@flash} current_scope={@current_scope}>
      <.header>
        Residences
        <:subtitle>Manage residence properties</:subtitle>
        <:actions>
          <.link patch={~p"/admin/residences/new"}>
            <.button>New Residence</.button>
          </.link>
        </:actions>
      </.header>

      <.table
        id="residences"
        rows={@streams.residences}
        row_click={fn {_id, residence} -> JS.navigate(~p"/admin/residences/#{residence}/edit") end}
      >
        <:col :let={{_id, residence}} label="Title"><%= residence.title %></:col>
        <:col :let={{_id, residence}} label="Address"><%= residence.address %></:col>
        <:col :let={{_id, residence}} label="Floor Count"><%= residence.floor_count %></:col>
        <:col :let={{_id, residence}} label="Created">
          <%= Calendar.strftime(residence.inserted_at, "%Y-%m-%d") %>
        </:col>
        <:action :let={{_id, residence}}>
          <div class="sr-only">
            <.link navigate={~p"/admin/residences/#{residence}/edit"}>Edit</.link>
          </div>
          <.button
            phx-click={JS.push("delete", value: %{id: residence.id}) |> hide("##{residence.id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.button>
        </:action>
      </.table>

      <%= if @live_action in [:new, :edit] do %>
        <div id="residence-modal" class="fixed inset-0 z-10 overflow-y-auto">
          <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
            <div class="fixed inset-0 transition-opacity" aria-hidden="true">
              <div class="absolute inset-0 bg-gray-500 opacity-75" phx-click={JS.patch(~p"/admin/residences")}></div>
            </div>
            <div class="inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full sm:p-6">
              <.live_component
                module={Trackguests3Web.AdminLive.ResidenceFormComponent}
                id={@residence.id || :new}
                title={@page_title}
                action={@live_action}
                residence={@residence}
                patch={~p"/admin/residences"}
              />
            </div>
          </div>
        </div>
      <% end %>
    </Trackguests3Web.Layouts.admin>
    """
  end
end