defmodule Trackguests3Web.RoomsLive.Form do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation
  alias Trackguests3.Accomodation.Rooms

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
            <span class="text-platinum font-medium">
              <%= if @live_action == :new, do: "Add Room", else: "Edit Room" %>
            </span>
          <% else %>
            <span>→</span>
            <span class="text-platinum font-medium">Rooms</span>
          <% end %>
        </nav>

        <div class="card-luxury">
          <.header>
            {@page_title}
            <:subtitle>
              <%= if @residence do %>
                Add a new room to {String.capitalize(@residence.title)}
              <% else %>
                Use this form to manage room records in your database.
              <% end %>
            </:subtitle>
          </.header>

          <.form for={@form} id="rooms-form" phx-change="validate" phx-submit="save" class="space-y-6">
            <!-- Residence Selection (only show if no residence context) -->
            <%= if !@residence do %>
              <.input 
                field={@form[:residence_id]} 
                type="select" 
                label="Property" 
                options={@residence_options}
                class="input-luxury"
                prompt="Select a property"
              />
            <% end %>
            
            <.input 
              field={@form[:title]} 
              type="text" 
              label="Room Name/Number" 
              class="input-luxury"
              placeholder="e.g., Suite 101, Penthouse A"
            />
            
            <.input 
              field={@form[:floor]} 
              type="number" 
              label="Floor" 
              class="input-luxury"
              placeholder="e.g., 1, 2, 3..."
            />
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <.input 
                field={@form[:needs_fob]} 
                type="checkbox" 
                label="Requires Key Fob Access"
                class="checkbox-luxury"
              />
              
              <.input 
                field={@form[:accepts_guests]} 
                type="checkbox" 
                label="Accepts Guests"
                class="checkbox-luxury"
              />
            </div>
            
            <.input 
              field={@form[:memo]} 
              type="textarea" 
              label="Notes & Amenities" 
              class="textarea-luxury"
              placeholder="Special instructions, amenities, access notes..."
              rows="3"
            />

            <div class="flex items-center justify-between">
              <button type="button" 
                      phx-click="cancel" 
                      class="btn-secondary-luxury">
                Cancel
              </button>
              
              <button type="submit" 
                      phx-disable-with="Saving..." 
                      class="btn-luxury">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                </svg>
                Save Room
              </button>
            </div>
          </.form>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    residence_id = params["residence_id"]
    residence = if residence_id, do: Accomodation.get_residence!(residence_id), else: nil

    {:ok,
     socket
     |> assign(:current_scope, %{})
     |> assign(:residence, residence)
     |> assign(:residence_options, get_residence_options())
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp get_residence_options do
    Accomodation.list_residences()
    |> Enum.map(&{&1.title, &1.id})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    rooms = Accomodation.get_rooms!(id)

    socket
    |> assign(:page_title, "Edit Room")
    |> assign(:rooms, rooms)
    |> assign(:form, to_form(Accomodation.change_rooms(rooms)))
  end

  defp apply_action(socket, :new, params) do
    rooms = %Rooms{}

    # If we have a residence context, pre-populate the residence_id
    rooms =
      if socket.assigns.residence do
        %{rooms | residence_id: socket.assigns.residence.id}
      else
        rooms
      end

    socket
    |> assign(:page_title, "New Room")
    |> assign(:rooms, rooms)
    |> assign(:form, to_form(Accomodation.change_rooms(rooms)))
  end

  @impl true
  def handle_event("validate", %{"rooms" => rooms_params}, socket) do
    changeset = Accomodation.change_rooms(socket.assigns.rooms, rooms_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"rooms" => rooms_params}, socket) do
    save_rooms(socket, socket.assigns.live_action, rooms_params)
  end

  def handle_event("cancel", _params, socket) do
    {:noreply,
     push_navigate(socket, to: return_path(socket.assigns.return_to, socket.assigns.rooms))}
  end

  defp save_rooms(socket, :edit, rooms_params) do
    case Accomodation.update_rooms(socket.assigns.rooms, rooms_params) do
      {:ok, rooms} ->
        {:noreply,
         socket
         |> put_flash(:info, "Room updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, rooms))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_rooms(socket, :new, rooms_params) do
    case Accomodation.create_rooms(rooms_params) do
      {:ok, rooms} ->
        Phoenix.PubSub.broadcast(
          Trackguests3.PubSub,
          "dashboard_updates",
          {:dashboard_update, %{}}
        )

        {:noreply,
         socket
         |> put_flash(:info, "Room created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, rooms))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_to("show"), do: "show"
  defp return_to("residence"), do: "residence"
  defp return_to(_), do: "index"

  defp return_path("index", _rooms), do: ~p"/rooms"
  defp return_path("show", rooms), do: ~p"/rooms/#{rooms}"

  defp return_path("residence", _rooms)
    ~p"/residences/#{socket.assigns.residence.id}"
  end

  defp return_path("residence", rooms), do: ~p"/residences/#{rooms.residence_id}"
  defp return_path(_, rooms), do: ~p"/rooms/#{rooms}"
end
