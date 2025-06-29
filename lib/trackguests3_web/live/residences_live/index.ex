defmodule Trackguests3Web.ResidencesLive.Index do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="space-y-6">
        <!-- Breadcrumb Navigation -->
        <nav class="flex items-center space-x-2 text-sm text-gray-600">
          <a href="/" class="nav-link-luxury">Dashboard</a>
          <span>→</span>
          <span class="text-platinum font-medium">Properties</span>
        </nav>

        <div class="card-luxury">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h1 class="text-2xl font-bold text-platinum">Properties</h1>
              <p class="text-gray-600 mt-1">Manage your luxury properties and estates</p>
            </div>

            <a href="/residences/new" class="btn-luxury inline-flex items-center">
              <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
              </svg>
              Add Property
            </a>
          </div>

          <%= if @residences == [] do %>
            <div class="text-center py-12">
              <svg class="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-4m-5 0H3m2 0h3M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
              </svg>
              <h3 class="text-lg font-semibold text-gray-900 mb-2">No properties yet</h3>
              <p class="text-gray-600 mb-6">Add your first luxury property to start managing guests.</p>
              <a href="/residences/new" class="btn-luxury">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                </svg>
                Add First Property
              </a>
            </div>
          <% else %>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <%= for residence <- @residences do %>
                <div class="bg-gradient-to-br from-white to-gray-50 rounded-xl border border-gray-200 p-6 hover:shadow-lg transition-all duration-200">
                  <div class="flex items-start justify-between mb-4">
                    <div class="flex-1">
                      <h3 class="text-lg font-semibold text-platinum mb-1">{residence.title}</h3>
                      <p class="text-sm text-gray-600">{residence.address}</p>
                    </div>
                  </div>

                  <div class="flex items-center space-x-4 mb-4">
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gradient-to-r from-blue-100 to-blue-200 text-blue-800">
                      <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-4m-5 0H3m2 0h3M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                      </svg>
                      {residence.floor_count} floors
                    </span>
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gradient-to-r from-green-100 to-green-200 text-green-800">
                      <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z"/>
                      </svg>
                      {residence.room_count || 0} rooms
                    </span>
                  </div>

                  <div class="flex items-center justify-between">
                    <span class="text-xs text-gray-500">
                      Created {Calendar.strftime(residence.inserted_at, "%b %d, %Y")}
                    </span>
                    <div class="flex items-center space-x-2">
                      <a href={"/residences/#{residence.id}"} 
                         class="text-sm nav-link-luxury px-3 py-1 rounded-lg hover:bg-gray-100 transition-colors">
                        View
                      </a>
                      <a href={"/residences/#{residence.id}/edit"} 
                         class="text-sm bg-gray-100 hover:bg-gray-200 text-gray-700 px-3 py-1 rounded-lg transition-colors">
                        Edit
                      </a>
                      <button phx-click="delete" 
                              phx-value-id={residence.id}
                              data-confirm="Are you sure you want to delete this property? This will also delete all associated rooms."
                              class="text-sm bg-red-100 hover:bg-red-200 text-red-700 px-3 py-1 rounded-lg transition-colors">
                        Delete
                      </button>
                    </div>
                  </div>
                </div>
              <% end %>
            </div>
          <% end %>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    residences = Accomodation.list_residences_with_stats()

    {:ok,
     socket
     |> assign(:current_scope, %{})
     |> assign(:residences, residences)
     |> assign(:page_title, "Properties")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    residence = Accomodation.get_residence!(id)
    {:ok, _} = Accomodation.delete_residence(residence)

    # Update the residence list
    updated_residences = Enum.filter(socket.assigns.residences, &(&1.id != id))

    # Broadcast dashboard update for real-time stats
    Phoenix.PubSub.broadcast(
      Trackguests3.PubSub,
      "dashboard_updates",
      {:dashboard_update, %{}}
    )

    {:noreply,
     socket
     |> assign(:residences, updated_residences)
     |> put_flash(:info, "Property deleted successfully")}
  end
end
