defmodule Trackguests3Web.PropertyLive.Dashboard do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accounts
  alias Trackguests3.Repo

  @impl true
  def mount(_params, _session, socket) do
    user = Accounts.get_user_with_property!(socket.assigns.current_scope.user.id)
    
    # Preload rooms if property exists
    user = if user.property do
      %{user | property: Repo.preload(user.property, :rooms)}
    else
      user
    end
    
    socket =
      socket
      |> assign(:user, user)
      |> assign(:page_title, "My Property")

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("select_property", %{"residence_id" => residence_id}, socket) do
    case Accounts.update_user_property(socket.assigns.user, %{property_id: residence_id}) do
      {:ok, updated_user} ->
        updated_user = Accounts.get_user_with_property!(updated_user.id)
        
        {:noreply,
         socket
         |> assign(:user, updated_user)
         |> put_flash(:info, "Property selected successfully")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to select property")}
    end
  end

  @impl true
  def handle_event("create_property", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/property/new")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <div>
        <h1 class="text-3xl font-bold text-gray-900">My Property</h1>
        <p class="mt-2 text-sm text-gray-600">
          Manage your property, rooms, and guest access.
        </p>
      </div>

      <%= if @user.property do %>
        <!-- Current Property -->
        <div class="bg-white shadow rounded-lg p-6">
          <h2 class="text-xl font-semibold text-gray-900 mb-4">Current Property</h2>
          <div class="flex items-start space-x-4">
            <div class="flex-1">
              <h3 class="text-lg font-medium text-gray-900"><%= @user.property.title %></h3>
              <p class="text-gray-600"><%= @user.property.address %></p>
              <p class="text-sm text-gray-500"><%= @user.property.floor_count %> floors</p>
            </div>
            <div class="flex space-x-2">
              <.link navigate={~p"/property/edit"} class="inline-flex items-center px-3 py-2 border border-gray-300 shadow-sm text-sm leading-4 font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                Edit Property
              </.link>
              <.link navigate={~p"/property/rooms"} class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                Manage Rooms
              </.link>
            </div>
          </div>
        </div>
      <% else %>
        <!-- No Property Selected -->
        <div class="text-center">
          <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
          </svg>
          <h3 class="mt-2 text-sm font-medium text-gray-900">No property selected</h3>
          <p class="mt-1 text-sm text-gray-500">Get started by creating a new property or selecting an existing one.</p>
          <div class="mt-6 flex justify-center space-x-4">
            <.button phx-click="create_property">
              Create New Property
            </.button>
            <.link navigate={~p"/property/select"} class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              Select Existing Property
            </.link>
          </div>
        </div>
      <% end %>

      <%= if @user.property do %>
        <!-- Property Stats -->
        <div class="bg-white shadow rounded-lg">
          <div class="px-4 py-5 sm:p-6">
            <h3 class="text-lg leading-6 font-medium text-gray-900">Property Overview</h3>
            <div class="mt-5 grid grid-cols-1 gap-5 sm:grid-cols-3">
              <!-- Total Rooms -->
              <div class="bg-white overflow-hidden shadow rounded-lg">
                <div class="p-5">
                  <div class="flex items-center">
                    <div class="flex-shrink-0">
                      <svg class="h-6 w-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2H5a2 2 0 00-2-2z" />
                      </svg>
                    </div>
                    <div class="ml-5 w-0 flex-1">
                      <dl>
                        <dt class="text-sm font-medium text-gray-500 truncate">Total Rooms</dt>
                        <dd class="text-lg font-medium text-gray-900">
                          <%= length(@user.property.rooms || []) %>
                        </dd>
                      </dl>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Floors -->
              <div class="bg-white overflow-hidden shadow rounded-lg">
                <div class="p-5">
                  <div class="flex items-center">
                    <div class="flex-shrink-0">
                      <svg class="h-6 w-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5" />
                      </svg>
                    </div>
                    <div class="ml-5 w-0 flex-1">
                      <dl>
                        <dt class="text-sm font-medium text-gray-500 truncate">Floors</dt>
                        <dd class="text-lg font-medium text-gray-900"><%= @user.property.floor_count %></dd>
                      </dl>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Quick Actions -->
              <div class="bg-white overflow-hidden shadow rounded-lg">
                <div class="p-5">
                  <div class="flex items-center justify-center h-full">
                    <.link navigate={~p"/property/rooms/new"} class="w-full">
                      <.button class="w-full">Add Room</.button>
                    </.link>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end