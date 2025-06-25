defmodule Trackguests3Web.ResidenceLive.Form do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation
  alias Trackguests3.Accomodation.Residence

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage residence records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="residence-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:address]} type="text" label="Address" />
        <.input field={@form[:floor_count]} type="number" label="Floor count" />
        <.input field={@form[:logo]} type="text" label="Logo" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Residence</.button>
          <.button navigate={return_path(@return_to, @residence)}>Cancel</.button>
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
    residence = Accomodation.get_residence!(id)

    socket
    |> assign(:page_title, "Edit Residence")
    |> assign(:residence, residence)
    |> assign(:form, to_form(Accomodation.change_residence(residence)))
  end

  defp apply_action(socket, :new, _params) do
    residence = %Residence{}

    socket
    |> assign(:page_title, "New Residence")
    |> assign(:residence, residence)
    |> assign(:form, to_form(Accomodation.change_residence(residence)))
  end

  @impl true
  def handle_event("validate", %{"residence" => residence_params}, socket) do
    changeset = Accomodation.change_residence(socket.assigns.residence, residence_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"residence" => residence_params}, socket) do
    save_residence(socket, socket.assigns.live_action, residence_params)
  end

  defp save_residence(socket, :edit, residence_params) do
    case Accomodation.update_residence(socket.assigns.residence, residence_params) do
      {:ok, residence} ->
        {:noreply,
         socket
         |> put_flash(:info, "Residence updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, residence))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_residence(socket, :new, residence_params) do
    case Accomodation.create_residence(residence_params) do
      {:ok, residence} ->
        {:noreply,
         socket
         |> put_flash(:info, "Residence created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, residence))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _residence), do: ~p"/residences"
  defp return_path("show", residence), do: ~p"/residences/#{residence}"
end
