defmodule Trackguests3Web.PropertyLive.Select do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accounts
  alias Trackguests3.Accomodation

  @impl true
  def mount(_params, _session, socket) do
    residences = Accomodation.list_residences()
    user = Accounts.get_user_with_property!(socket.assigns.current_scope.user.id)

    {:ok,
     socket
     |> assign(:residences, residences)
     |> assign(:user, user)
     |> assign(:page_title, "Select Property")}
  end

  @impl true
  def handle_event("select_property", %{"residence_id" => residence_id}, socket) do
    case Accounts.update_user_property(socket.assigns.user, %{property_id: residence_id}) do
      {:ok, _updated_user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Property selected successfully")
         |> push_navigate(to: ~p"/property")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to select property")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <div>
        <h1 class="text-3xl font-bold text-gray-900">Select Property</h1>
        <p class="mt-2 text-sm text-gray-600">
          Choose an existing property to manage.
        </p>
      </div>

      <%= if @residences == [] do %>
        <div class="text-center py-12">
          <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
          </svg>
          <h3 class="mt-2 text-sm font-medium text-gray-900">No properties available</h3>
          <p class="mt-1 text-sm text-gray-500">There are no properties to select from. Create a new one instead.</p>
          <div class="mt-6">
            <.link navigate={~p"/property/new"}>
              <.button>Create New Property</.button>
            </.link>
          </div>
        </div>
      <% else %>
        <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
          <%= for residence <- @residences do %>
            <div class="bg-white overflow-hidden shadow rounded-lg">
              <div class="p-6">
                <div class="flex items-center">
                  <div class="flex-shrink-0">
                    <svg class="h-6 w-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                    </svg>
                  </div>
                  <div class="ml-4 flex-1">
                    <h3 class="text-lg font-medium text-gray-900"><%= residence.title %></h3>
                    <p class="text-sm text-gray-500"><%= residence.address %></p>
                    <p class="text-xs text-gray-400 mt-1"><%= residence.floor_count %> floors</p>
                  </div>
                  <%= if @user.property_id == residence.id do %>
                    <div class="ml-4 flex-shrink-0">
                      <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                        Selected
                      </span>
                    </div>
                  <% end %>
                </div>
                <%= if @user.property_id != residence.id do %>
                  <div class="mt-4">
                    <.button
                      phx-click="select_property"
                      phx-value-residence_id={residence.id}
                      class="w-full"
                    >
                      Select This Property
                    </.button>
                  </div>
                <% end %>
              </div>
            </div>
          <% end %>
        </div>
      <% end %>

      <div class="flex justify-center">
        <.link navigate={~p"/property"} class="text-sm font-medium text-gray-700 hover:text-gray-500">
          ← Back to Property Dashboard
        </.link>
      </div>
    </div>
    """
  end
end