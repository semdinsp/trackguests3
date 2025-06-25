defmodule Trackguests3Web.RoomsLive.Form do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation
  alias Trackguests3.Accomodation.Rooms

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage rooms records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="rooms-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:floor]} type="number" label="Floor" />
        <.input field={@form[:needs_fob]} type="checkbox" label="Needs fob" />
        <.input field={@form[:memo]} type="text" label="Memo" />
        <.input field={@form[:accepts_guests]} type="checkbox" label="Accepts guests" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Rooms</.button>
          <.button navigate={return_path(@return_to, @rooms)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    rooms = Accomodation.get_rooms!(id)

    socket
    |> assign(:page_title, "Edit Rooms")
    |> assign(:rooms, rooms)
    |> assign(:form, to_form(Accomodation.change_rooms(rooms)))
  end

  defp apply_action(socket, :new, _params) do
    rooms = %Rooms{}

    socket
    |> assign(:page_title, "New Rooms")
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

  defp save_rooms(socket, :edit, rooms_params) do
    case Accomodation.update_rooms(socket.assigns.rooms, rooms_params) do
      {:ok, rooms} ->
        {:noreply,
         socket
         |> put_flash(:info, "Rooms updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, rooms))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_rooms(socket, :new, rooms_params) do
    case Accomodation.create_rooms(rooms_params) do
      {:ok, rooms} ->
        {:noreply,
         socket
         |> put_flash(:info, "Rooms created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, rooms))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _rooms), do: ~p"/rooms"
  defp return_path("show", rooms), do: ~p"/rooms/#{rooms}"
end
