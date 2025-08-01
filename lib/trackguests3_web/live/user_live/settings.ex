defmodule Trackguests3Web.UserLive.Settings do
  use Trackguests3Web, :live_view

  on_mount {Trackguests3Web.UserAuth, :require_sudo_mode}

  alias Trackguests3.Accounts
  alias Trackguests3.Accomodation

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="space-y-8">
        <.header class="text-center">
          <%= gettext("Account Settings") %>
          <:subtitle><%= gettext("Manage your account preferences and security settings") %></:subtitle>
        </.header>

        <!-- Guest History Card -->
        <div class="card-luxury">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h2 class="text-xl font-semibold text-platinum"><%= gettext("Guest History") %></h2>
              <p class="text-gray-600 mt-1"><%= gettext("View and export guest check-in/check-out records") %></p>
            </div>
            <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
            </svg>
          </div>

          <div class="space-y-4">
            <p class="text-gray-700">
              <%= gettext("Access comprehensive guest history reports with customizable date ranges. View detailed check-in and check-out records, and export data for analysis.") %>
            </p>
            
            <div class="flex items-center space-x-4">
              <a href="/history" class="btn-luxury inline-flex items-center">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                <%= gettext("View Guest History") %>
              </a>
              
              <div class="text-sm text-gray-500">
                <span class="inline-flex items-center">
                  <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                  </svg>
                  <%= gettext("Browse by date range • Export to CSV") %>
                </span>
              </div>
            </div>
          </div>
        </div>

        <!-- Language/Locale Settings Card -->
        <div class="card-luxury">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h2 class="text-xl font-semibold text-platinum"><%= gettext("Language Preferences") %></h2>
              <p class="text-gray-600 mt-1"><%= gettext("Choose your preferred language") %></p>
            </div>
            <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5h12M9 3v2m1.048 9.5A18.022 18.022 0 016.412 9m6.088 9h7M11 21l5-10 5 10M12.751 5C11.783 10.77 8.07 15.61 3 18.129"/>
            </svg>
          </div>

          <.form for={@locale_form} id="locale_form" phx-submit="update_locale" phx-change="validate_locale">
            <div class="space-y-6">
              <div>
                <label class="block text-sm font-medium text-platinum mb-4"><%= gettext("Select Language") %></label>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  <%= for locale_option <- @available_locales do %>
                    <label class="relative cursor-pointer">
                      <input
                        type="radio"
                        name={@locale_form[:locale].name}
                        value={locale_option.value}
                        checked={@locale_form[:locale].value == locale_option.value}
                        class="sr-only"
                        phx-change="validate_locale"
                      />
                      <div class={"flex items-center p-4 rounded-xl border-2 transition-all duration-200 #{if @locale_form[:locale].value == locale_option.value, do: "border-purple-500 bg-purple-50 ring-2 ring-purple-200", else: "border-gray-200 hover:border-gray-300 hover:bg-gray-50"}"}>
                        <div class="flex items-center space-x-3">
                          <div class="text-2xl">{locale_option.flag}</div>
                          <div>
                            <div class="font-medium text-gray-900">{locale_option.name}</div>
                            <div class="text-sm text-gray-500">{locale_option.native_name}</div>
                          </div>
                        </div>
                      </div>
                    </label>
                  <% end %>
                </div>
              </div>
              <.button class="btn-luxury" phx-disable-with={gettext("Saving...")}>
                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
                <%= gettext("Save Language") %>
              </.button>
            </div>
          </.form>
        </div>

        <!-- Guest Language Selection Card -->
        <div class="card-luxury">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h2 class="text-xl font-semibold text-platinum"><%= gettext("Guest Language Options") %></h2>
              <p class="text-gray-600 mt-1"><%= gettext("Select which languages guests can choose from during check-in/check-out") %></p>
            </div>
            <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
            </svg>
          </div>

          <.form for={@guest_locales_form} id="guest_locales_form" phx-submit="update_guest_locales" phx-change="validate_guest_locales">
            <div class="space-y-6">
              <div>
                <label class="block text-sm font-medium text-platinum mb-4"><%= gettext("Available Languages for Guests") %></label>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                  <%= for locale_option <- @available_locales do %>
                    <label class="relative cursor-pointer">
                      <input
                        type="checkbox"
                        name="user[locales_to_show_guests][]"
                        value={locale_option.value}
                        checked={locale_option.value in (@guest_locales_form[:locales_to_show_guests].value || [])}
                        class="sr-only"
                        phx-change="validate_guest_locales"
                      />
                      <div class={"flex items-center p-3 rounded-lg border-2 transition-all duration-200 #{if locale_option.value in (@guest_locales_form[:locales_to_show_guests].value || []), do: "border-purple-500 bg-purple-50 ring-1 ring-purple-200", else: "border-gray-200 hover:border-gray-300 hover:bg-gray-50"}"}>
                        <div class="flex items-center space-x-3 flex-1">
                          <div class="text-xl">{locale_option.flag}</div>
                          <div>
                            <div class="font-medium text-gray-900 text-sm">{locale_option.name}</div>
                            <div class="text-xs text-gray-500">{locale_option.native_name}</div>
                          </div>
                        </div>
                        <%= if locale_option.value in (@guest_locales_form[:locales_to_show_guests].value || []) do %>
                          <svg class="w-5 h-5 text-purple-600" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                          </svg>
                        <% end %>
                      </div>
                    </label>
                  <% end %>
                </div>
              </div>
              
              <div class="p-4 bg-blue-50 border border-blue-200 rounded-xl">
                <div class="flex items-start space-x-3">
                  <div class="flex-shrink-0">
                    <svg class="w-5 h-5 text-blue-500 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                      <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"/>
                    </svg>
                  </div>
                  <div>
                    <p class="text-sm font-medium text-blue-900"><%= gettext("Guest Language Selection") %></p>
                    <p class="text-sm text-blue-700 mt-1">
                      <%= gettext("Selected languages will appear as options on guest check-in and check-out pages. At least one language must be selected.") %>
                    </p>
                  </div>
                </div>
              </div>

              <.button class="btn-luxury" phx-disable-with={gettext("Saving...")}>
                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
                <%= gettext("Save Guest Language Options") %>
              </.button>
            </div>
          </.form>
        </div>

        <!-- Email Settings Card -->
        <div class="card-luxury">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h2 class="text-xl font-semibold text-platinum"><%= gettext("Email Address") %></h2>
              <p class="text-gray-600 mt-1"><%= gettext("Update your email address") %></p>
            </div>
            <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207" />
            </svg>
          </div>

          <.form for={@email_form} id="email_form" phx-submit="update_email" phx-change="validate_email">
            <div class="space-y-4">
              <.input
                field={@email_form[:email]}
                type="email"
                label={gettext("Email Address")}
                autocomplete="username"
                required
                class="input-luxury"
              />
              <.button class="btn-luxury" phx-disable-with={gettext("Changing...")}>
                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
                </svg>
                <%= gettext("Change Email") %>
              </.button>
            </div>
          </.form>
        </div>

        <!-- Theme Settings Card -->
        <div class="card-luxury">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h2 class="text-xl font-semibold text-platinum"><%= gettext("Theme Preferences") %></h2>
              <p class="text-gray-600 mt-1"><%= gettext("Choose your preferred theme") %></p>
            </div>
            <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zM21 5a2 2 0 00-2-2h-4a2 2 0 00-2 2v12a4 4 0 004 4h4a2 2 0 002-2V5z" />
            </svg>
          </div>

          <.form for={@theme_form} id="theme_form" phx-submit="update_theme" phx-change="validate_theme">
            <div class="space-y-6">
              <div>
                <label class="block text-sm font-medium text-platinum mb-4"><%= gettext("Select Theme") %></label>
                <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                  <%= for theme <- @available_themes do %>
                    <label class="relative cursor-pointer">
                      <input
                        type="radio"
                        name={@theme_form[:theme].name}
                        value={theme.value}
                        checked={@theme_form[:theme].value == theme.value}
                        class="sr-only"
                        phx-change="validate_theme"
                      />
                      <div class={"flex items-center justify-center p-4 rounded-xl border-2 transition-all duration-200 #{if @theme_form[:theme].value == theme.value, do: "border-purple-500 bg-purple-50 ring-2 ring-purple-200", else: "border-gray-200 hover:border-gray-300 hover:bg-gray-50"}"}>
                        <div class="text-center">
                          <div class={"w-12 h-12 rounded-lg mx-auto mb-2 #{theme.preview_class}"}></div>
                          <span class="text-sm font-medium text-gray-900">{theme.name}</span>
                        </div>
                      </div>
                    </label>
                  <% end %>
                </div>
              </div>
              <.button class="btn-luxury" phx-disable-with={gettext("Saving...")}>
                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
                <%= gettext("Save Theme") %>
              </.button>
            </div>
          </.form>
        </div>

        <!-- Property Settings Card -->
        <div class="card-luxury">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h2 class="text-xl font-semibold text-platinum"><%= gettext("Property Management") %></h2>
              <p class="text-gray-600 mt-1"><%= gettext("Select your managed property for check-ins") %></p>
            </div>
            <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
            </svg>
          </div>

          <.form for={@property_form} id="property_form" phx-submit="update_property" phx-change="validate_property">
            <div class="space-y-4">
              <%= if @current_property do %>
                <div class="p-4 bg-blue-50 border border-blue-200 rounded-xl mb-4">
                  <div class="flex items-center justify-between">
                    <div>
                      <h3 class="font-medium text-blue-900"><%= gettext("Current Property") %></h3>
                      <p class="text-sm text-blue-700"><%= @current_property.title %></p>
                      <p class="text-xs text-blue-600"><%= @current_property.address %></p>
                    </div>
                    <span class="inline-flex items-center px-2 py-1 text-xs font-medium bg-blue-100 text-blue-800 rounded-full">
                      <%= gettext("Active") %>
                    </span>
                  </div>
                </div>
              <% end %>
              
              <.input
                field={@property_form[:property_id]}
                type="select"
                label={gettext("Select Property")}
                options={@property_options}
                prompt={gettext("Choose a property to manage...")}
                class="select input-luxury"
              />
              
              <div class="flex items-center space-x-3">
                <.button class="btn-luxury" phx-disable-with={gettext("Saving...")}>
                  <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                  <%= gettext("Save Property Selection") %>
                </.button>
                
                <%= if @current_property do %>
                  <button type="button" phx-click="clear_property" class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                    <%= gettext("Clear Selection") %>
                  </button>
                <% end %>
              </div>
              
              <div class="text-sm text-gray-500">
                <p><strong><%= gettext("Note:") %></strong> <%= gettext("Selecting a property will make it your default for guest check-ins and property management features.") %></p>
              </div>
            </div>
          </.form>
        </div>

        <!-- Password Settings Card -->
        <div class="card-luxury">
          <div class="flex items-center justify-between mb-6">
            <div>
              <h2 class="text-xl font-semibold text-platinum"><%= gettext("Password & Security") %></h2>
              <p class="text-gray-600 mt-1"><%= gettext("Update your password to keep your account secure") %></p>
            </div>
            <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
            </svg>
          </div>

          <.form
            for={@password_form}
            id="password_form"
            action={~p"/users/update-password"}
            method="post"
            phx-change="validate_password"
            phx-submit="update_password"
            phx-trigger-action={@trigger_submit}
          >
            <input
              name={@password_form[:email].name}
              type="hidden"
              id="hidden_user_email"
              autocomplete="username"
              value={@current_email}
            />
            <div class="space-y-4">
              <.input
                field={@password_form[:password]}
                type="password"
                label={gettext("New Password")}
                autocomplete="new-password"
                required
                class="input-luxury"
              />
              <.input
                field={@password_form[:password_confirmation]}
                type="password"
                label={gettext("Confirm New Password")}
                autocomplete="new-password"
                class="input-luxury"
              />
              <.button class="btn-luxury" phx-disable-with={gettext("Saving...")}>
                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                </svg>
                <%= gettext("Update Password") %>
              </.button>
            </div>
          </.form>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_scope.user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = Accounts.get_user_with_property!(socket.assigns.current_scope.user.id)
    
    email_changeset = Accounts.change_user_email(user, %{}, validate_email: false)
    password_changeset = Accounts.change_user_password(user, %{}, hash_password: false)
    theme_changeset = Accounts.change_user_theme(user, %{})
    locale_changeset = Accounts.change_user_locale(user, %{})
    guest_locales_changeset = Accounts.change_user_guest_locales(user, %{})
    property_changeset = Accounts.change_user_property(user, %{})

    available_themes = [
      %{name: "Light", value: "light", preview_class: "bg-gradient-to-br from-white to-gray-100 border border-gray-200"},
      %{name: "Cupcake", value: "cupcake", preview_class: "bg-gradient-to-br from-pink-200 to-pink-300"},
      %{name: "Cyberpunk", value: "cyberpunk", preview_class: "bg-gradient-to-br from-cyan-400 to-purple-500"},
      %{name: "Greyscale", value: "greyscale", preview_class: "bg-gradient-to-br from-gray-300 to-gray-600"},
      %{name: "Retro", value: "retro", preview_class: "bg-gradient-to-br from-yellow-300 to-orange-400"},
      %{name: "Synthwave", value: "synthwave", preview_class: "bg-gradient-to-br from-purple-600 to-pink-500"},
      %{name: "Valentine", value: "valentine", preview_class: "bg-gradient-to-br from-red-300 to-pink-400"},
      %{name: "Emerald", value: "emerald", preview_class: "bg-gradient-to-br from-green-300 to-emerald-400"},
      %{name: "Corporate", value: "corporate", preview_class: "bg-gradient-to-br from-blue-300 to-blue-500"},
      %{name: "Luxury", value: "luxury", preview_class: "bg-gradient-to-br from-purple-300 to-indigo-400"},
      %{name: "Dracula", value: "dracula", preview_class: "bg-gradient-to-br from-purple-900 to-gray-900"},
      %{name: "Night", value: "night", preview_class: "bg-gradient-to-br from-gray-800 to-black"}
    ]

    available_locales = [
      %{name: "English", native_name: "English", value: "en", flag: "🇺🇸"},
      %{name: "Spanish", native_name: "Español", value: "es", flag: "🇪🇸"},
      %{name: "French", native_name: "Français", value: "fr", flag: "🇫🇷"},
      %{name: "German", native_name: "Deutsch", value: "de", flag: "🇩🇪"},
      %{name: "Italian", native_name: "Italiano", value: "it", flag: "🇮🇹"},
      %{name: "Portuguese", native_name: "Português", value: "pt", flag: "🇵🇹"},
      %{name: "Japanese", native_name: "日本語", value: "ja", flag: "🇯🇵"},
      %{name: "Korean", native_name: "한국어", value: "ko", flag: "🇰🇷"},
      %{name: "Chinese", native_name: "中文", value: "zh", flag: "🇨🇳"},
      %{name: "Russian", native_name: "Русский", value: "ru", flag: "🇷🇺"},
      %{name: "Arabic", native_name: "العربية", value: "ar", flag: "🇸🇦"}
    ]

    # Get property options
    property_options = try do
      Accomodation.list_residences()
      |> Enum.map(&{&1.title, &1.id})
    rescue
      _ -> []
    end

    socket =
      socket
      |> assign(:current_email, user.email)
      |> assign(:current_property, user.property)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:theme_form, to_form(theme_changeset))
      |> assign(:locale_form, to_form(locale_changeset))
      |> assign(:guest_locales_form, to_form(guest_locales_changeset))
      |> assign(:property_form, to_form(property_changeset))
      |> assign(:property_options, property_options)
      |> assign(:available_themes, available_themes)
      |> assign(:available_locales, available_locales)
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"user" => user_params} = params

    email_form =
      socket.assigns.current_scope.user
      |> Accounts.change_user_email(user_params, validate_email: false)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form)}
  end

  def handle_event("update_email", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_scope.user
    true = Accounts.sudo_mode?(user)

    case Accounts.change_user_email(user, user_params) do
      %{valid?: true} = changeset ->
        Accounts.deliver_user_update_email_instructions(
          Ecto.Changeset.apply_action!(changeset, :insert),
          user.email,
          &url(~p"/users/settings/confirm-email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info)}

      changeset ->
        {:noreply, assign(socket, :email_form, to_form(changeset, action: :insert))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"user" => user_params} = params

    password_form =
      socket.assigns.current_scope.user
      |> Accounts.change_user_password(user_params, hash_password: false)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form)}
  end

  def handle_event("update_password", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_scope.user
    true = Accounts.sudo_mode?(user)

    case Accounts.change_user_password(user, user_params) do
      %{valid?: true} = changeset ->
        {:noreply, assign(socket, trigger_submit: true, password_form: to_form(changeset))}

      changeset ->
        {:noreply, assign(socket, password_form: to_form(changeset, action: :insert))}
    end
  end

  def handle_event("validate_theme", params, socket) do
    %{"user" => user_params} = params

    theme_form =
      socket.assigns.current_scope.user
      |> Accounts.change_user_theme(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, theme_form: theme_form)}
  end

  def handle_event("update_theme", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_scope.user

    case Accounts.update_user_theme(user, user_params) do
      {:ok, _user} ->
        info = gettext("Theme updated successfully!")
        {:noreply, socket |> put_flash(:info, info)}

      {:error, changeset} ->
        {:noreply, assign(socket, :theme_form, to_form(changeset, action: :insert))}
    end
  end

  def handle_event("validate_locale", params, socket) do
    %{"user" => user_params} = params

    locale_form =
      socket.assigns.current_scope.user
      |> Accounts.change_user_locale(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, locale_form: locale_form)}
  end

  def handle_event("update_locale", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_scope.user

    case Accounts.update_user_locale(user, user_params) do
      {:ok, _user} ->
        info = gettext("Language updated successfully!")
        {:noreply, socket |> put_flash(:info, info)}

      {:error, changeset} ->
        {:noreply, assign(socket, :locale_form, to_form(changeset, action: :insert))}
    end
  end

  def handle_event("validate_guest_locales", params, socket) do
    %{"user" => user_params} = params

    guest_locales_form =
      socket.assigns.current_scope.user
      |> Accounts.change_user_guest_locales(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, guest_locales_form: guest_locales_form)}
  end

  def handle_event("update_guest_locales", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_scope.user

    case Accounts.update_user_guest_locales(user, user_params) do
      {:ok, _user} ->
        info = gettext("Guest language options updated successfully!")
        {:noreply, socket |> put_flash(:info, info)}

      {:error, changeset} ->
        {:noreply, assign(socket, :guest_locales_form, to_form(changeset, action: :insert))}
    end
  end

  def handle_event("validate_property", params, socket) do
    %{"user" => user_params} = params

    property_form =
      socket.assigns.current_scope.user
      |> Accounts.change_user_property(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, property_form: property_form)}
  end

  def handle_event("update_property", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_scope.user

    case Accounts.update_user_property(user, user_params) do
      {:ok, updated_user} ->
        # Get the updated user with property preloaded
        user_with_property = Accounts.get_user_with_property!(updated_user.id)
        
        info = gettext("Property selection updated successfully!")
        {:noreply, 
         socket 
         |> assign(:current_property, user_with_property.property)
         |> put_flash(:info, info)}

      {:error, changeset} ->
        {:noreply, assign(socket, :property_form, to_form(changeset, action: :insert))}
    end
  end

  def handle_event("clear_property", _params, socket) do
    user = socket.assigns.current_scope.user

    case Accounts.update_user_property(user, %{property_id: nil}) do
      {:ok, _updated_user} ->
        # Reset the property form
        property_changeset = Accounts.change_user_property(user, %{})
        
        info = gettext("Property selection cleared successfully!")
        {:noreply, 
         socket 
         |> assign(:current_property, nil)
         |> assign(:property_form, to_form(property_changeset))
         |> put_flash(:info, info)}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, gettext("Failed to clear property selection"))}
    end
  end
end
