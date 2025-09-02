defmodule Trackguests3Web.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is rendered as component
  in regular views and live views.
  """
  use Trackguests3Web, :html

  embed_templates("layouts/*")

  @doc """
  Renders the app layout

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layout.app>
      
  """
  attr(:flash, :map, required: true, doc: "the map of flash messages")

  attr(:current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"
  )

  slot(:inner_block, required: true)

  def app(assigns) do
    ~H"""
    <div class="min-h-screen gradient-bg-luxury" id="main-content">
      <!-- Secondary Navigation for Quick Actions -->
      <div class="bg-white/50 backdrop-blur-sm border-b border-gray-200/30 py-3">
        <div class="max-w-7xl mx-auto px-6 lg:px-8">
          <div class="flex items-center justify-center space-x-4">
            <.link href="/visitor/check-in" class="btn-luxury inline-flex items-center text-sm">
              <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
              </svg>
              Guest Check-In
            </.link>
            <.link href="/visitor/check-out" class="btn-luxury inline-flex items-center text-sm">
              <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
              </svg>
              Guest Check-Out
            </.link>
            <%= if @current_scope && Map.get(@current_scope, :user) do %>
              <.link href="/rooms" class="nav-link-luxury text-sm">
                <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                </svg>
                Manage Rooms
              </.link>
            <% end %>
          </div>
        </div>
      </div>

      <!-- Main Content Area with Luxury Styling -->
      <main class="max-w-7xl mx-auto px-6 lg:px-8 py-12" role="main">
        {render_slot(@inner_block)}
      </main>
    </div>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Renders the admin layout
  """
  attr(:flash, :map, required: true, doc: "the map of flash messages")

  attr(:current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"
  )

  slot(:inner_block, required: true)

  def admin(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50">
      <!-- Admin Navigation Header -->
      <header class="bg-white shadow-sm border-b border-gray-200">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex justify-between items-center h-16">
            <div class="flex items-center space-x-8">
              <div class="flex items-center space-x-4">
                <div class="w-8 h-8 bg-red-600 rounded-lg flex items-center justify-center">
                  <span class="text-white font-bold text-sm">A</span>
                </div>
                <h1 class="text-xl font-semibold text-gray-900">Admin Panel</h1>
              </div>
              <nav class="hidden md:flex space-x-1">
                <.link href="/admin" class="px-3 py-2 rounded-md text-sm font-medium text-gray-700 hover:text-gray-900 hover:bg-gray-100">
                  Dashboard
                </.link>
                <.link href="/admin/users" class="px-3 py-2 rounded-md text-sm font-medium text-gray-700 hover:text-gray-900 hover:bg-gray-100">
                  Users
                </.link>
                <.link href="/admin/residences" class="px-3 py-2 rounded-md text-sm font-medium text-gray-700 hover:text-gray-900 hover:bg-gray-100">
                  Residences
                </.link>
                <.link href="/admin/rooms" class="px-3 py-2 rounded-md text-sm font-medium text-gray-700 hover:text-gray-900 hover:bg-gray-100">
                  Rooms
                </.link>
                <.link href="/admin/persons" class="px-3 py-2 rounded-md text-sm font-medium text-gray-700 hover:text-gray-900 hover:bg-gray-100">
                  Persons
                </.link>
                <.link href="/guides" class="px-3 py-2 rounded-md text-sm font-medium text-gray-700 hover:text-gray-900 hover:bg-gray-100">
                  <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                  </svg>
                  User Guides
                </.link>
              </nav>
            </div>
            <div class="flex items-center space-x-4">
              <.link href="/" class="text-sm text-gray-500 hover:text-gray-700">
                ← Back to Site
              </.link>
              <%= if @current_scope && Map.get(@current_scope, :user) do %>
                <span class="text-sm text-gray-600"><%= Map.get(@current_scope, :user) |> Map.get(:email) %></span>
                <.link href="/users/log-out" method="delete" class="text-sm text-gray-500 hover:text-gray-700">
                  Log out
                </.link>
              <% end %>
            </div>
          </div>
        </div>
      </header>

      <!-- Admin Content Area -->
      <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {render_slot(@inner_block)}
      </main>
    </div>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr(:flash, :map, required: true, doc: "the map of flash messages")
  attr(:id, :string, default: "flash-group", doc: "the optional id of flash container")

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <!-- Only show connection errors for logged-in users (not during logout redirect) -->
      <%= if assigns[:current_scope] && assigns.current_scope[:user] do %>
        <.flash
          id="client-error"
          kind={:error}
          title={gettext("We can't find the internet")}
          phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
          phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
          hidden
        >
          {gettext("Attempting to reconnect")}
          <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
        </.flash>

        <.flash
          id="server-error"
          kind={:error}
          title={gettext("Something went wrong!")}
          phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
          phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
          hidden
        >
          {gettext("Attempting to reconnect")}
          <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
        </.flash>
      <% end %>
    </div>
    """
  end
end
