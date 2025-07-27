defmodule Trackguests3Web.PropertyLive.RoomFormComponent do
  use Trackguests3Web, :live_component

  alias Trackguests3.Accomodation

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Manage room details for your property</:subtitle>
      </.header>

      <form
        for={@form}
        id="room-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-4"
      >
        <.input field={@form[:title]} type="text" label="Room Name" placeholder="e.g., Room 101" />
        <.input field={@form[:floor]} type="number" label="Floor" min="1" />
        <.input field={@form[:needs_fob]} type="checkbox" label="Requires Fob for Access" />
        <.input field={@form[:accepts_guests]} type="checkbox" label="Accepts Guests" />
        <.input field={@form[:memo]} type="textarea" label="Notes" placeholder="Any additional notes about this room" />
        
        <div class="flex justify-end space-x-3">
          <.link patch={@patch} class="text-sm leading-6 text-gray-900 font-semibold">Cancel</.link>
          <.button phx-disable-with="Saving...">Save Room</.button>
        </div>
      </form>
    </div>
    """
  end

  @impl true
  def update(%{room: room} = assigns, socket) do
    changeset = Accomodation.change_rooms(room)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"rooms" => room_params}, socket) do
    changeset =
      socket.assigns.room
      |> Accomodation.change_rooms(room_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"rooms" => room_params}, socket) do
    save_room(socket, socket.assigns.action, room_params)
  end

  defp save_room(socket, :edit, room_params) do
    case Accomodation.update_rooms(socket.assigns.room, room_params) do
      {:ok, room} ->
        notify_parent({:saved, room})

        {:noreply,
         socket
         |> put_flash(:info, "Room updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_room(socket, :new, room_params) do
    # Set the residence_id from the user's property
    room_params = Map.put(room_params, "residence_id", socket.assigns.user.property.id)
    
    case Accomodation.create_rooms(room_params) do
      {:ok, room} ->
        notify_parent({:saved, room})

        {:noreply,
         socket
         |> put_flash(:info, "Room created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end