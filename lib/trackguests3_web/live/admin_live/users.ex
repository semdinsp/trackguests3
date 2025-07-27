defmodule Trackguests3Web.AdminLive.Users do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :users, list_users())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, Accounts.get_user!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Users")
    |> assign(:user, nil)
  end

  @impl true
  def handle_info({Trackguests3Web.AdminLive.UserFormComponent, {:saved, user}}, socket) do
    {:noreply, stream_insert(socket, :users, user)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.delete_user(user)

    {:noreply, stream_delete(socket, :users, user)}
  end

  @impl true
  def handle_event("toggle_admin", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, updated_user} = Accounts.update_user_admin(user, %{admin: !user.admin})

    {:noreply, stream_insert(socket, :users, updated_user)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Trackguests3Web.Layouts.admin flash={@flash} current_scope={@current_scope}>
      <.header>
        Users
        <:subtitle>Manage user accounts and admin privileges</:subtitle>
      </.header>

      <.table
        id="users"
        rows={@streams.users}
        row_click={fn {_id, user} -> JS.navigate(~p"/admin/users/#{user}/edit") end}
      >
        <:col :let={{_id, user}} label="Email"><%= user.email %></:col>
        <:col :let={{_id, user}} label="Admin">
          <span class={"inline-flex px-2 py-1 text-xs font-semibold rounded-full " <> 
            if user.admin, do: "bg-green-100 text-green-800", else: "bg-gray-100 text-gray-800"}>
            <%= if user.admin, do: "Admin", else: "User" %>
          </span>
        </:col>
        <:col :let={{_id, user}} label="Confirmed">
          <span class={"inline-flex px-2 py-1 text-xs font-semibold rounded-full " <> 
            if user.confirmed_at, do: "bg-green-100 text-green-800", else: "bg-yellow-100 text-yellow-800"}>
            <%= if user.confirmed_at, do: "Yes", else: "No" %>
          </span>
        </:col>
        <:col :let={{_id, user}} label="Inserted">
          <%= Calendar.strftime(user.inserted_at, "%Y-%m-%d") %>
        </:col>
        <:action :let={{_id, user}}>
          <div class="sr-only">
            <.link navigate={~p"/admin/users/#{user}/edit"}>Edit</.link>
          </div>
          <.button
            phx-click="toggle_admin"
            phx-value-id={user.id}
            data-confirm="Are you sure?"
          >
            <%= if user.admin, do: "Remove Admin", else: "Make Admin" %>
          </.button>
        </:action>
      </.table>

      <%= if @live_action in [:edit] do %>
        <div id="user-modal" class="fixed inset-0 z-10 overflow-y-auto">
          <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
            <div class="fixed inset-0 transition-opacity" aria-hidden="true">
              <div class="absolute inset-0 bg-gray-500 opacity-75" phx-click={JS.patch(~p"/admin/users")}></div>
            </div>
            <div class="inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-sm sm:w-full sm:p-6">
              <.live_component
                module={Trackguests3Web.AdminLive.UserFormComponent}
                id={@user.id}
                title={@page_title}
                action={@live_action}
                user={@user}
                patch={~p"/admin/users"}
              />
            </div>
          </div>
        </div>
      <% end %>
    </Trackguests3Web.Layouts.admin>
    """
  end

  defp list_users do
    Accounts.list_users()
  end
end