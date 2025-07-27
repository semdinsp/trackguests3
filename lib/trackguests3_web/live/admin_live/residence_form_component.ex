defmodule Trackguests3Web.AdminLive.ResidenceFormComponent do
  use Trackguests3Web, :live_component

  alias Trackguests3.Accomodation

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage residence properties</:subtitle>
      </.header>

      <form
        for={@form}
        id="residence-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-4"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:address]} type="text" label="Address" />
        <.input field={@form[:floor_count]} type="number" label="Floor count" />
        <div>
          <.button phx-disable-with="Saving...">Save Residence</.button>
        </div>
      </form>
    </div>
    """
  end

  @impl true
  def update(%{residence: residence} = assigns, socket) do
    changeset = Accomodation.change_residence(residence)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"residence" => residence_params}, socket) do
    changeset =
      socket.assigns.residence
      |> Accomodation.change_residence(residence_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"residence" => residence_params}, socket) do
    save_residence(socket, socket.assigns.action, residence_params)
  end

  defp save_residence(socket, :edit, residence_params) do
    case Accomodation.update_residence(socket.assigns.residence, residence_params) do
      {:ok, residence} ->
        notify_parent({:saved, residence})

        {:noreply,
         socket
         |> put_flash(:info, "Residence updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_residence(socket, :new, residence_params) do
    case Accomodation.create_residence(residence_params) do
      {:ok, residence} ->
        notify_parent({:saved, residence})

        {:noreply,
         socket
         |> put_flash(:info, "Residence created successfully")
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