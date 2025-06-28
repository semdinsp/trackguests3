defmodule Trackguests3Web.RoomsLive.Index do
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
          <a href="/residences" class="nav-link-luxury">Properties</a>
          <%= if @residence do %>
            <span>→</span>
            <a href={"/residences/#{@residence.id}"} class="nav-link-luxury">{@residence.title}</a>
            <span>→</span>
            <span class="text-platinum font-medium">Rooms</span>
          <% else %>
            <span>→</span>
            <span class="text-platinum font-medium">All Rooms</span>
          <% end %>
        </nav>

        <div class="card-luxury">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h1 class="text-2xl font-bold text-platinum">
                <%= if @residence do %>
                  Rooms in {@residence.title}
                <% else %>
                  All Rooms
                <% end %>
              </h1>
              <p class="text-gray-600 mt-1">
                <%= if @residence do %>
                  Manage rooms and suites in this property
                <% else %>
                  Manage all rooms across your properties
                <% end %>
              </p>
            </div>

            <div class="flex items-center space-x-3">
              <%= if @residence do %>
                <a href={"/residences/#{@residence.id}/rooms/new?return_to=residence"} 
                   class="btn-luxury inline-flex items-center">
                  <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                  </svg>
                  Add Room
                </a>
              <% else %>
                <a href="/rooms/new" class="btn-luxury inline-flex items-center">
                  <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                  </svg>
                  Add Room
                </a>
              <% end %>
            </div>
          </div>

          <%= if @rooms == [] do %>
            <div class="text-center py-12">
              <svg class="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z"/>
              </svg>
              <h3 class="text-lg font-semibold text-gray-900 mb-2">
                <%= if @residence do %>
                  No rooms in this property yet
                <% else %>
                  No rooms created yet
                <% end %>
              </h3>
              <p class="text-gray-600 mb-6">
                <%= if @residence do %>
                  Add your first room to start managing guests in this property.
                <% else %>
                  Create rooms within your properties to start tracking guests.
                <% end %>
              </p>
              <%= if @residence do %>
                <a href={"/residences/#{@residence.id}/rooms/new?return_to=residence"} 
                   class="btn-luxury">
                  <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                  </svg>
                  Add First Room
                </a>
              <% else %>
                <a href="/rooms/new" class="btn-luxury">Add First Room</a>
              <% end %>
            </div>
          <% else %>
            <div class="overflow-hidden">
              <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <%= for room <- @rooms do %>
                  <div class="card-luxury border border-gray-200 hover:shadow-luxury-lg transition-all duration-300">
                    <div class="flex items-start justify-between mb-4">
                      <div>
                        <h3 class="font-semibold text-platinum text-lg">{room.title}</h3>
                        <%= if !@residence do %>
                          <p class="text-sm text-gray-600 mt-1">
                            Property: {room.residence && room.residence.title || "Unknown"}
                          </p>
                        <% end %>
                      </div>
                      <div class="text-right">
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gradient-to-r from-gray-100 to-gray-200 text-gray-800">
                          Floor {room.floor}
                        </span>
                      </div>
                    </div>

                    <div class="space-y-2 mb-4">
                      <div class="flex items-center space-x-2">
                        <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-10.712 3.712M15 7l-3.5 3.5M15 7l3.5 3.5M3 13a9 9 0 1018 0v0"/>
                        </svg>
                        <span class="text-sm text-gray-600">
                          {if room.needs_fob, do: "Key fob required", else: "Standard access"}
                        </span>
                      </div>
                      
                      <div class="flex items-center space-x-2">
                        <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857"/>
                        </svg>
                        <span class="text-sm text-gray-600">
                          {if room.accepts_guests, do: "Accepts guests", else: "No guests"}
                        </span>
                      </div>

                      <%= if room.memo && String.trim(room.memo) != "" do %>
                        <div class="flex items-start space-x-2">
                          <svg class="w-4 h-4 text-gray-400 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 8h10M7 12h4m1 8l-4-4H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-3l-4 4z"/>
                          </svg>
                          <span class="text-sm text-gray-600">{String.slice(room.memo, 0, 50)}{if String.length(room.memo) > 50, do: "..."}</span>
                        </div>
                      <% end %>
                    </div>

                    <div class="flex items-center justify-between pt-4 border-t border-gray-100">
                      <div class="flex items-center space-x-2">
                        <a href={"/rooms/#{room.id}"} class="text-sm nav-link-luxury">
                          View Details
                        </a>
                      </div>
                      <div class="flex items-center space-x-2">
                        <a href={"/rooms/#{room.id}/edit"} 
                           class="text-sm bg-gray-100 hover:bg-gray-200 text-gray-700 px-3 py-1 rounded-lg transition-colors">
                          Edit
                        </a>
                        <button phx-click="delete" 
                                phx-value-id={room.id}
                                data-confirm="Are you sure you want to delete this room?"
                                class="text-sm bg-red-100 hover:bg-red-200 text-red-700 px-3 py-1 rounded-lg transition-colors">
                          Delete
                        </button>
                      </div>
                    </div>
                  </div>
                <% end %>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    residence_id = params["residence_id"]
    residence = if residence_id, do: Accomodation.get_residence!(residence_id), else: nil

    rooms =
      if residence do
        Accomodation.list_rooms()
        |> Enum.filter(&(&1.residence_id == residence.id))
      else
        # For general room listing, preload residence info
        Accomodation.list_rooms()
        |> Enum.map(fn room ->
          residence =
            if room.residence_id, do: Accomodation.get_residence!(room.residence_id), else: nil

          %{room | residence: residence}
        end)
      end

    {:ok,
     socket
     |> assign(:current_scope, %{})
     |> assign(:residence, residence)
     |> assign(:rooms, rooms)
     |> assign(:page_title, if(residence, do: "Rooms in #{residence.title}", else: "All Rooms"))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    rooms = Accomodation.get_rooms!(id)
    {:ok, _} = Accomodation.delete_rooms(rooms)

    # Update the room list
    updated_rooms = Enum.filter(socket.assigns.rooms, &(&1.id != id))

    # Broadcast dashboard update for real-time stats
    Phoenix.PubSub.broadcast(
      Trackguests3.PubSub,
      "dashboard_updates",
      {:dashboard_update, %{}}
    )

    {:noreply,
     socket
     |> assign(:rooms, updated_rooms)
     |> put_flash(:info, "Room deleted successfully")}
  end
end
