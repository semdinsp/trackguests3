defmodule Trackguests3Web.ResidencesLive.Show do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation
  alias Trackguests3.Persons

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
          <span>→</span>
          <span class="text-platinum font-medium">{@residence.title}</span>
        </nav>

        <!-- Property Header -->
        <div class="card-luxury">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h1 class="text-3xl font-bold text-platinum">{@residence.title}</h1>
              <p class="text-gray-600 mt-2">{@residence.address}</p>
              <div class="flex items-center space-x-4 mt-3">
                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-gradient-to-r from-blue-100 to-blue-200 text-blue-800">
                  <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-4m-5 0H3m2 0h3M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                  </svg>
                  {@residence.floor_count} floors
                </span>
                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-gradient-to-r from-green-100 to-green-200 text-green-800">
                  <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z"/>
                  </svg>
                  {length(@rooms)} rooms
                </span>
                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-gradient-to-r from-purple-100 to-purple-200 text-purple-800">
                  <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M17 20v-2M7 20v-2M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2m3 2v-2a3 3 0 00-3-3m0 3h3m-3 0l1.5-3 1.5 3M17 7v3a3 3 0 01-3 3"/>
                  </svg>
                  {length(@current_visitors)} current guests
                </span>
              </div>
            </div>

            <div class="flex items-center space-x-3">
              <a href={"/residences/#{@residence.id}/rooms"} class="btn-secondary-luxury">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z"/>
                </svg>
                Manage Rooms
              </a>
              <a href={"/residences/#{@residence.id}/edit"} class="btn-luxury">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                </svg>
                Edit Property
              </a>
            </div>
          </div>
        </div>

        <!-- Current Visitors Table -->
        <div class="card-luxury">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h2 class="text-xl font-bold text-platinum">Current Visitors</h2>
              <p class="text-gray-600 mt-1">Guests currently checked in to this property</p>
            </div>
            <a href="/visitor/check-in" class="btn-luxury">
              <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-3-2a3 3 0 11-6 0 3 3 0 016 0z"/>
              </svg>
              Check In New Guest
            </a>
          </div>

          <%= if @current_visitors == [] do %>
            <div class="text-center py-12">
              <svg class="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857"/>
              </svg>
              <h3 class="text-lg font-semibold text-gray-900 mb-2">No current visitors</h3>
              <p class="text-gray-600 mb-6">There are no guests currently checked in to this property.</p>
              <a href="/visitor/check-in" class="btn-luxury">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-3-2a3 3 0 11-6 0 3 3 0 016 0z"/>
                </svg>
                Check In First Guest
              </a>
            </div>
          <% else %>
            <div class="overflow-x-auto">
              <table class="w-full">
                <thead>
                  <tr class="border-b border-gray-200">
                    <th class="text-left py-4 px-4 font-semibold text-platinum">Guest Name</th>
                    <th class="text-left py-4 px-4 font-semibold text-platinum">Room</th>
                    <th class="text-left py-4 px-4 font-semibold text-platinum">Check-in Date</th>
                    <th class="text-left py-4 px-4 font-semibold text-platinum">Duration</th>
                    <th class="text-left py-4 px-4 font-semibold text-platinum">Contact</th>
                    <th class="text-right py-4 px-4 font-semibold text-platinum">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <%= for visitor <- @current_visitors do %>
                    <tr class="border-b border-gray-100 hover:bg-gray-50/50 transition-colors">
                      <td class="py-4 px-4">
                        <div class="font-medium text-platinum">{visitor.name}</div>
                        <%= if visitor.company && String.trim(visitor.company) != "" do %>
                          <div class="text-sm text-gray-500">{visitor.company}</div>
                        <% end %>
                      </td>
                      <td class="py-4 px-4">
                        <%= if visitor.room do %>
                          <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gradient-to-r from-blue-100 to-blue-200 text-blue-800">
                            <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z"/>
                            </svg>
                            {visitor.room.title}
                          </span>
                        <% else %>
                          <span class="text-gray-400 text-sm">No room assigned</span>
                        <% end %>
                      </td>
                      <td class="py-4 px-4">
                        <div class="text-sm text-gray-900">
                          {Calendar.strftime(visitor.inserted_at, "%b %d, %Y")}
                        </div>
                        <div class="text-xs text-gray-500">
                          {Calendar.strftime(visitor.inserted_at, "%I:%M %p")}
                        </div>
                      </td>
                      <td class="py-4 px-4">
                        <div class="text-sm text-gray-900">
                          {calculate_duration(visitor.inserted_at)} days
                        </div>
                      </td>
                      <td class="py-4 px-4">
                        <%= if visitor.email && String.trim(visitor.email) != "" do %>
                          <div class="text-sm text-gray-600">{visitor.email}</div>
                        <% end %>
                        <%= if visitor.phone && String.trim(visitor.phone) != "" do %>
                          <div class="text-sm text-gray-600">{visitor.phone}</div>
                        <% end %>
                      </td>
                      <td class="py-4 px-4">
                        <div class="flex items-center justify-end space-x-2">
                          <button phx-click="check_out" 
                                  phx-value-id={visitor.id}
                                  data-confirm="Are you sure you want to check out {visitor.name}?"
                                  class="text-sm bg-green-100 hover:bg-green-200 text-green-700 px-3 py-1 rounded-lg transition-colors">
                            <svg class="w-4 h-4 mr-1 inline" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
                            </svg>
                            Check Out
                          </button>
                          <a href={"/persons/#{visitor.id}"} 
                             class="text-sm bg-gray-100 hover:bg-gray-200 text-gray-700 px-3 py-1 rounded-lg transition-colors">
                            View Details
                          </a>
                        </div>
                      </td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          <% end %>
        </div>

        <!-- Rooms Overview -->
        <div class="card-luxury">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h2 class="text-xl font-bold text-platinum">Rooms in this Property</h2>
              <p class="text-gray-600 mt-1">Overview of all rooms and their current status</p>
            </div>
            <a href={"/residences/#{@residence.id}/rooms/new?return_to=residence"} class="btn-luxury">
              <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
              </svg>
              Add Room
            </a>
          </div>

          <%= if @rooms == [] do %>
            <div class="text-center py-8">
              <svg class="w-12 h-12 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z"/>
              </svg>
              <h3 class="text-lg font-semibold text-gray-900 mb-2">No rooms yet</h3>
              <p class="text-gray-600 mb-4">Add rooms to start managing guests in this property.</p>
              <a href={"/residences/#{@residence.id}/rooms/new?return_to=residence"} class="btn-luxury">
                Add First Room
              </a>
            </div>
          <% else %>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              <%= for room <- @rooms do %>
                <div class="bg-gradient-to-r from-gray-50 to-white border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">
                  <div class="flex items-center justify-between mb-2">
                    <h3 class="font-semibold text-platinum">{room.title}</h3>
                    <span class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-gradient-to-r from-blue-100 to-blue-200 text-blue-800">
                      Floor {room.floor}
                    </span>
                  </div>
                  <div class="space-y-1 text-sm text-gray-600">
                    <div class="flex items-center">
                      <svg class="w-3 h-3 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-10.712 3.712"/>
                      </svg>
                      {if room.needs_fob, do: "Key fob required", else: "Standard access"}
                    </div>
                    <div class="flex items-center">
                      <svg class="w-3 h-3 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857"/>
                      </svg>
                      {if room.accepts_guests, do: "Accepts guests", else: "No guests allowed"}
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
  def mount(%{"id" => id}, _session, socket) do
    residence = Accomodation.get_residence!(id)

    rooms =
      Accomodation.list_rooms_with_residences()
      |> Enum.filter(&(&1.residence_id == residence.id))

    current_visitors = Persons.list_current_visitors_for_residence(residence.id)

    # Subscribe to visitor updates for real-time changes
    Phoenix.PubSub.subscribe(Trackguests3.PubSub, "visitor_updates")

    {:ok,
     socket
     |> assign(:current_scope, %{})
     |> assign(:residence, residence)
     |> assign(:rooms, rooms)
     |> assign(:current_visitors, current_visitors)
     |> assign(:page_title, residence.title)}
  end

  @impl true
  def handle_event("check_out", %{"id" => visitor_id}, socket) do
    case Persons.check_out_visitor(visitor_id) do
      {:ok, _visitor} ->
        # Update the current visitors list
        updated_visitors = Enum.filter(socket.assigns.current_visitors, &(&1.id != visitor_id))

        # Broadcast the update for real-time dashboard updates
        Phoenix.PubSub.broadcast(
          Trackguests3.PubSub,
          "dashboard_updates",
          {:dashboard_update, %{}}
        )

        Phoenix.PubSub.broadcast(
          Trackguests3.PubSub,
          "visitor_updates",
          {:visitor_checked_out, visitor_id}
        )

        {:noreply,
         socket
         |> assign(:current_visitors, updated_visitors)
         |> put_flash(:info, "Guest checked out successfully")}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to check out guest")}
    end
  end

  @impl true
  def handle_info({:visitor_checked_out, visitor_id}, socket) do
    updated_visitors = Enum.filter(socket.assigns.current_visitors, &(&1.id != visitor_id))
    {:noreply, assign(socket, :current_visitors, updated_visitors)}
  end

  def handle_info({:visitor_checked_in, _visitor}, socket) do
    # Refresh the visitor list when someone checks in
    current_visitors = Persons.list_current_visitors_for_residence(socket.assigns.residence.id)
    {:noreply, assign(socket, :current_visitors, current_visitors)}
  end

  def handle_info(_, socket), do: {:noreply, socket}

  defp calculate_duration(check_in_time) do
    now = DateTime.utc_now()
    diff = DateTime.diff(now, check_in_time, :day)
    # At least 1 day
    max(diff, 1)
  end
end
