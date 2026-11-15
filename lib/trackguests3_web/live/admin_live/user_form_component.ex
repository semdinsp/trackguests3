defmodule Trackguests3Web.AdminLive.UserFormComponent do
  use Trackguests3Web, :live_component

  alias Trackguests3.Accounts
  alias Trackguests3.Accomodation

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Edit user admin privileges and details</:subtitle>
      </.header>

      <.form
        for={@form}
        id="user-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-4"
      >
        <.input field={@form[:email]} type="email" label="Email" readonly />
        <.input field={@form[:admin]} type="checkbox" label="Admin" />
        <.input
          field={@form[:property_id]}
          type="select"
          label={gettext("Property")}
          options={@property_options}
          prompt={gettext("No property")}
        />
        <div>
          <.button phx-disable-with="Saving...">Save User</.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user_admin(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:property_options, Enum.map(Accomodation.list_residences(), &{&1.title, &1.id}))
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Accounts.change_user_admin(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    save_user(socket, socket.assigns.action, user_params)
  end

  defp save_user(socket, :edit, user_params) do
    case Accounts.update_user_admin(socket.assigns.user, user_params) do
      {:ok, user} ->
        notify_parent({:saved, user})

        {:noreply,
         socket
         |> put_flash(:info, "User updated successfully")
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