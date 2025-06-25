defmodule Trackguests3Web.ResidenceLive.Index do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="page-header">
        <div class="flex justify-between items-center">
          <div>
            <h1 class="page-title">Property Management</h1>
            <p class="page-subtitle">Manage your hospitality properties and residences</p>
          </div>
          <button 
            phx-click={JS.navigate(~p"/residences/new")}
            class="btn-hospitality inline-flex items-center"
          >
            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
            </svg>
            Add New Property
          </button>
        </div>
      </div>

      <div class="card-hospitality">
        <div class="table-hospitality">
          <table class="w-full">
            <thead>
              <tr>
                <th class="text-left">Property Name</th>
                <th class="text-left">Address</th>
                <th class="text-left">Floors</th>
                <th class="text-left">Status</th>
                <th class="text-right">Actions</th>
              </tr>
            </thead>
            <tbody>
              <%= if @residences_empty? do %>
                <tr>
                  <td colspan="5" class="text-center py-12 text-stone-500">
                    <div class="flex flex-col items-center">
                      <svg class="w-12 h-12 text-stone-300 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-4m-5 0H3m2 0h4M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                      </svg>
                      <p class="text-lg font-medium text-stone-400 mb-2">No properties yet</p>
                      <p class="text-stone-400">Add your first property to get started</p>
                    </div>
                  </td>
                </tr>
              <% else %>
                <%= for {id, residence} <- @streams.residences do %>
                  <tr id={id} class="cursor-pointer hover:bg-stone-50" phx-click={JS.navigate(~p"/residences/#{residence}")}>
                    <td class="font-medium text-stone-800">
                      <%= residence.title %>
                    </td>
                    <td class="text-stone-600">
                      <%= residence.address %>
                    </td>
                    <td class="text-stone-600">
                      <%= residence.floor_count %> floors
                    </td>
                    <td>
                      <span class="status-badge status-available">Active</span>
                    </td>
                    <td class="text-right">
                      <div class="flex justify-end space-x-2">
                        <button 
                          phx-click={JS.navigate(~p"/residences/#{residence}/edit")} 
                          class="text-emerald-600 hover:text-emerald-700 text-sm font-medium"
                        >
                          Edit
                        </button>
                        <button 
                          phx-click={JS.push("delete", value: %{id: residence.id}) |> hide("##{id}")}
                          data-confirm="Are you sure you want to delete this property?"
                          class="text-red-600 hover:text-red-700 text-sm font-medium"
                        >
                          Delete
                        </button>
                      </div>
                    </td>
                  </tr>
                <% end %>
              <% end %>
            </tbody>
          </table>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     residences = Accomodation.list_residences()

     socket
     |> assign(:page_title, "Property Management")
     |> assign(:residences_empty?, residences == [])
     |> stream(:residences, residences)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    residence = Accomodation.get_residence!(id)
    {:ok, _} = Accomodation.delete_residence(residence)

    {:noreply, stream_delete(socket, :residences, residence)}
  end
end
