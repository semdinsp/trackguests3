defmodule Trackguests3Web.ResidenceLive.Index do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="page-header-luxury">
        <div class="flex justify-between items-center">
          <div>
            <h1 class="page-title-luxury">Property Management</h1>
            <p class="page-subtitle-luxury">Manage your luxury hospitality properties and residences</p>
          </div>
          <button 
            phx-click={JS.navigate(~p"/residences/new")}
            class="btn-luxury inline-flex items-center"
          >
            <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
            </svg>
            Add New Property
          </button>
        </div>
      </div>

      <%= if @residences_empty? do %>
        <div class="card-luxury text-center py-20">
          <div class="max-w-lg mx-auto">
            <div class="w-24 h-24 gradient-header-luxury rounded-3xl flex items-center justify-center mx-auto mb-8 shadow-luxury">
              <svg class="w-12 h-12 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-4m-5 0H3m2 0h4M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
              </svg>
            </div>
            <h3 class="text-3xl font-bold text-platinum mb-6">Welcome to Elite Property Management</h3>
            <p class="text-gray-600 mb-10 text-lg leading-relaxed">
              Begin curating your luxury property portfolio by adding your first residence. 
              Experience sophisticated room management, elegant guest tracking, and premium hospitality operations.
            </p>
            <button 
              phx-click={JS.navigate(~p"/residences/new")}
              class="btn-luxury inline-flex items-center text-lg px-10 py-5"
            >
              <svg class="w-6 h-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
              </svg>
              Create Your First Property
            </button>
          </div>
        </div>
      <% else %>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <%= for {id, residence} <- @streams.residences do %>
            <div id={id} class="card-luxury group cursor-pointer" phx-click={JS.navigate(~p"/residences/#{residence}")}>
              <div class="flex items-start justify-between mb-6">
                <div class="w-16 h-16 gradient-header-luxury rounded-2xl flex items-center justify-center shadow-luxury">
                  <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-4m-5 0H3m2 0h4M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                  </svg>
                </div>
                <span class="status-active-luxury">Premium</span>
              </div>
              
              <h3 class="text-2xl font-bold text-platinum mb-3 group-hover:text-gray-900 transition-colors">
                <%= residence.title %>
              </h3>
              
              <p class="text-gray-600 mb-6 leading-relaxed">
                <%= residence.address %>
              </p>
              
              <div class="flex items-center justify-between text-sm text-gray-500 mb-8">
                <span class="flex items-center font-medium">
                  <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z"/>
                  </svg>
                  <%= residence.floor_count %> floors
                </span>
              </div>
              
              <div class="flex space-x-3">
                <button 
                  phx-click={JS.navigate(~p"/residences/#{residence}/edit")} 
                  class="btn-platinum flex-1 text-sm py-3"
                  onclick="event.stopPropagation()"
                >
                  Edit Property
                </button>
                <button 
                  phx-click={JS.push("delete", value: %{id: residence.id}) |> hide("##{id}")}
                  data-confirm="Are you certain you want to remove this luxury property?"
                  class="text-red-600 hover:text-red-700 hover:bg-red-50 px-4 py-3 rounded-xl text-sm font-semibold transition-all duration-300"
                  onclick="event.stopPropagation()"
                >
                  Remove
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
     |> assign(:page_title, "Luxury Property Management")
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
