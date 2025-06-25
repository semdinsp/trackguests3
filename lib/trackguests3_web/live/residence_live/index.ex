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
            class="btn-primary inline-flex items-center"
          >
            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
            </svg>
            Add New Property
          </button>
        </div>
      </div>

      <%= if @residences_empty? do %>
        <div class="card-modern text-center py-16">
          <div class="max-w-md mx-auto">
            <div class="w-20 h-20 gradient-header rounded-2xl flex items-center justify-center mx-auto mb-6">
              <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-4m-5 0H3m2 0h4M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
              </svg>
            </div>
            <h3 class="text-2xl font-bold text-gray-900 mb-4">Welcome to Property Management</h3>
            <p class="text-gray-600 mb-8 leading-relaxed">
              Start building your property portfolio by adding your first residence. 
              Track rooms, manage guests, and streamline your hospitality operations.
            </p>
            <button 
              phx-click={JS.navigate(~p"/residences/new")}
              class="btn-primary inline-flex items-center"
            >
              <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
              </svg>
              Create Your First Property
            </button>
          </div>
        </div>
      <% else %>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <%= for {id, residence} <- @streams.residences do %>
            <div id={id} class="card-modern group cursor-pointer" phx-click={JS.navigate(~p"/residences/#{residence}")}>
              <div class="flex items-start justify-between mb-4">
                <div class="w-12 h-12 gradient-header rounded-xl flex items-center justify-center">
                  <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-4m-5 0H3m2 0h4M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                  </svg>
                </div>
                <span class="status-badge status-active">Active</span>
              </div>
              
              <h3 class="text-xl font-bold text-gray-900 mb-2 group-hover:text-blue-600 transition-colors">
                <%= residence.title %>
              </h3>
              
              <p class="text-gray-600 mb-4 line-clamp-2">
                <%= residence.address %>
              </p>
              
              <div class="flex items-center justify-between text-sm text-gray-500 mb-6">
                <span class="flex items-center">
                  <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z"/>
                  </svg>
                  <%= residence.floor_count %> floors
                </span>
              </div>
              
              <div class="flex space-x-2">
                <button 
                  phx-click={JS.navigate(~p"/residences/#{residence}/edit")} 
                  class="btn-outline flex-1 text-sm py-2"
                  onclick="event.stopPropagation()"
                >
                  Edit
                </button>
                <button 
                  phx-click={JS.push("delete", value: %{id: residence.id}) |> hide("##{id}")}
                  data-confirm="Are you sure you want to delete this property?"
                  class="text-red-600 hover:text-red-700 hover:bg-red-50 px-3 py-2 rounded-lg text-sm font-medium transition-colors"
                  onclick="event.stopPropagation()"
                >
                  Delete
                </button>
              </div>
            </div>
          <% end %>
        </div>
      <% end %>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    residences = Accomodation.list_residences()

    {:ok,
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
