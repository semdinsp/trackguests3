defmodule Trackguests3Web.PropertyLive.Rooms do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accounts
  alias Trackguests3.Accomodation
  alias Trackguests3.Accomodation.Rooms

  @impl true
  def mount(_params, _session, socket) do
    user = Accounts.get_user_with_property!(socket.assigns.current_scope.user.id)
    
    if user.property do
      rooms = Accomodation.list_rooms_for_residence(user.property.id)
      
      {:ok,
       socket
       |> assign(:user, user)
       |> assign(:page_title, "Manage Rooms")
       |> stream(:rooms, rooms)}
    else
      {:ok,
       socket
       |> put_flash(:error, "No property selected")
       |> push_navigate(to: ~p"/property")}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:room, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:room, %Rooms{residence_id: socket.assigns.user.property.id})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    case Accomodation.get_room(id) do
      {:ok, room} ->
        # Check if user owns this room's residence
        if room.residence_id == socket.assigns.user.property.id do
          socket |> assign(:room, room)
        else
          socket
          |> put_flash(:error, "You don't have permission to edit this room")
          |> push_navigate(to: ~p"/property/rooms")
        end
      {:error, _} ->
        socket
        |> put_flash(:error, "Room not found")
        |> push_navigate(to: ~p"/property/rooms")
    end
  end

  @impl true
  def handle_info({Trackguests3Web.PropertyLive.RoomFormComponent, {:saved, room}}, socket) do
    {:noreply, stream_insert(socket, :rooms, room)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case Accomodation.get_room(id) do
      {:ok, room} ->
        if room.residence_id == socket.assigns.user.property.id do
          {:ok, _} = Accomodation.delete_rooms(room)
          {:noreply, stream_delete(socket, :rooms, room)}
        else
          {:noreply, put_flash(socket, :error, "You don't have permission to delete this room")}
        end
      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Room not found")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-3xl font-bold text-gray-900">Manage Rooms</h1>
          <p class="mt-2 text-sm text-gray-600">
            Property: <%= @user.property.title %>
          </p>
        </div>
        <.link navigate={~p"/property/rooms/new"}>
          <.button>Add Room</.button>
        </.link>
      </div>

      <div class="bg-white shadow rounded-lg">
        <.table id="rooms" rows={@streams.rooms}>
          <:col :let={{_id, room}} label="Room">
            <%= room.title %>
          </:col>
          <:col :let={{_id, room}} label="Floor">
            <%= room.floor %>
          </:col>
          <:col :let={{_id, room}} label="Needs Fob">
            <span class={"inline-flex px-2 py-1 text-xs font-semibold rounded-full " <> 
              if room.needs_fob, do: "bg-yellow-100 text-yellow-800", else: "bg-gray-100 text-gray-800"}>
              <%= if room.needs_fob, do: "Yes", else: "No" %>
            </span>
          </:col>
          <:col :let={{_id, room}} label="Accepts Guests">
            <span class={"inline-flex px-2 py-1 text-xs font-semibold rounded-full " <> 
              if room.accepts_guests, do: "bg-green-100 text-green-800", else: "bg-gray-100 text-gray-800"}>
              <%= if room.accepts_guests, do: "Yes", else: "No" %>
            </span>
          </:col>
          <:col :let={{_id, room}} label="Memo">
            <%= room.memo %>
          </:col>
          <:action :let={{_id, room}}>
            <div class="flex space-x-2">
              <.link navigate={~p"/property/rooms/#{room}/edit"} class="text-indigo-600 hover:text-indigo-900 text-sm">
                Edit
              </.link>
              <.button
                phx-click={JS.push("delete", value: %{id: room.id}) |> hide("##{room.id}")}
                data-confirm="Are you sure?"
                class="text-red-600 hover:text-red-900 text-sm bg-transparent border-0 p-0"
              >
                Delete
              </.button>
            </div>
          </:action>
        </.table>
      </div>

      <%= if @live_action in [:new, :edit] do %>
        <div id="room-modal" class="fixed inset-0 z-10 overflow-y-auto">
          <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
            <div class="fixed inset-0 transition-opacity" aria-hidden="true">
              <div class="absolute inset-0 bg-gray-500 opacity-75" phx-click={JS.navigate(~p"/property/rooms")}></div>
            </div>
            <div class="inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full sm:p-6">
              <.live_component
                module={Trackguests3Web.PropertyLive.RoomFormComponent}
                id={@room.id || :new}
                title={if @live_action == :new, do: "Add Room", else: "Edit Room"}
                action={@live_action}
                room={@room}
                user={@user}
                patch={~p"/property/rooms"}
              />
            </div>
          </div>
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