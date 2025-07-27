defmodule Trackguests3Web.PropertyLive.Form do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accounts
  alias Trackguests3.Accomodation
  alias Trackguests3.Accomodation.Residence

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Create Property")
    |> assign(:residence, %Residence{})
    |> assign(:changeset, Accomodation.change_residence(%Residence{}))
  end

  defp apply_action(socket, :edit, _params) do
    user = Accounts.get_user_with_property!(socket.assigns.current_scope.user.id)
    
    if user.property do
      socket
      |> assign(:page_title, "Edit Property")
      |> assign(:residence, user.property)
      |> assign(:changeset, Accomodation.change_residence(user.property))
    else
      socket
      |> put_flash(:error, "No property found to edit")
      |> push_navigate(to: ~p"/property")
    end
  end

  @impl true
  def handle_event("validate", %{"residence" => residence_params}, socket) do
    changeset =
      socket.assigns.residence
      |> Accomodation.change_residence(residence_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"residence" => residence_params}, socket) do
    save_residence(socket, socket.assigns.live_action, residence_params)
  end

  defp save_residence(socket, :new, residence_params) do
    case Accomodation.create_residence(residence_params) do
      {:ok, residence} ->
        # Link the new property to the current user
        user = socket.assigns.current_scope.user
        Accounts.update_user_property(user, %{property_id: residence.id})

        {:noreply,
         socket
         |> put_flash(:info, "Property created successfully")
         |> push_navigate(to: ~p"/property")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_residence(socket, :edit, residence_params) do
    case Accomodation.update_residence(socket.assigns.residence, residence_params) do
      {:ok, _residence} ->
        {:noreply,
         socket
         |> put_flash(:info, "Property updated successfully")
         |> push_navigate(to: ~p"/property")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto">
      <div class="space-y-6">
        <div>
          <h1 class="text-3xl font-bold text-gray-900"><%= @page_title %></h1>
          <p class="mt-2 text-sm text-gray-600">
            <%= if @live_action == :new do %>
              Create a new property to manage rooms and guests.
            <% else %>
              Update your property information.
            <% end %>
          </p>
        </div>

        <div class="bg-white shadow rounded-lg">
          <form phx-change="validate" phx-submit="save" class="space-y-6 p-6">
            <div>
              <.input
                field={@changeset[:title]}
                type="text"
                label="Property Name"
                placeholder="Enter property name"
                required
              />
            </div>

            <div>
              <.input
                field={@changeset[:address]}
                type="text"
                label="Address"
                placeholder="Enter property address"
                required
              />
            </div>

            <div>
              <.input
                field={@changeset[:floor_count]}
                type="number"
                label="Number of Floors"
                placeholder="Enter number of floors"
                min="1"
                required
              />
            </div>

            <div class="flex items-center justify-between pt-6 border-t border-gray-200">
              <.link navigate={~p"/property"} class="text-sm font-medium text-gray-700 hover:text-gray-500">
                Cancel
              </.link>
              <.button type="submit" phx-disable-with="Saving...">
                <%= if @live_action == :new, do: "Create Property", else: "Update Property" %>
              </.button>
            </div>
          </form>
        </div>
      </div>
    </div>
    """
  end
end