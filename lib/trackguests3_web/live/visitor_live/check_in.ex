defmodule Trackguests3Web.VisitorLive.CheckIn do
  use Trackguests3Web, :live_view

  alias Trackguests3.Accomodation
  alias Trackguests3.Persons
  alias Trackguests3.Persons.Person

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-2xl mx-auto">
        <div class="page-header-luxury text-center">
          <div class="w-20 h-20 gradient-header-luxury rounded-3xl flex items-center justify-center mx-auto mb-8 shadow-luxury">
            <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
            </svg>
          </div>
          <h1 class="page-title-luxury text-platinum">Visitor Check-In</h1>
          <p class="page-subtitle-luxury">Welcome to our luxury property. Please provide your details for a seamless check-in experience.</p>
        </div>

        <div class="card-luxury">
          <.form for={@form} id="check-in-form" phx-change="validate" phx-submit="check_in">
            <div class="space-y-8">
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label class="block text-sm font-semibold text-gray-700 mb-3">First Name *</label>
                  <.input
                    field={@form[:first_name]}
                    type="text"
                    placeholder="Enter your first name"
                    class="input-luxury w-full text-gray-900 placeholder:text-gray-500 bg-gray-50 border-2 border-gray-300 focus:border-gray-500 focus:ring-4 focus:ring-gray-200 rounded-xl px-6 py-4 font-medium transition-all duration-300"
                    required
                  />
                </div>

                <div>
                  <label class="block text-sm font-semibold text-gray-700 mb-3">Last Name *</label>
                  <.input
                    field={@form[:last_name]}
                    type="text"
                    placeholder="Enter your last name"
                    class="input-luxury w-full text-gray-900 placeholder:text-gray-500 bg-gray-50 border-2 border-gray-300 focus:border-gray-500 focus:ring-4 focus:ring-gray-200 rounded-xl px-6 py-4 font-medium transition-all duration-300"
                    required
                  />
                </div>
              </div>

              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label class="block text-sm font-semibold text-gray-700 mb-3">Email Address</label>
                  <.input
                    field={@form[:email]}
                    type="email"
                    placeholder="your.email@example.com"
                    class="input-luxury w-full text-gray-900 placeholder:text-gray-500 bg-gray-50 border-2 border-gray-300 focus:border-gray-500 focus:ring-4 focus:ring-gray-200 rounded-xl px-6 py-4 font-medium transition-all duration-300"
                  />
                </div>

                <div>
                  <label class="block text-sm font-semibold text-gray-700 mb-3">Phone Number</label>
                  <.input
                    field={@form[:phone]}
                    type="text"
                    placeholder="Your phone number"
                    class="input-luxury w-full text-gray-900 placeholder:text-gray-500 bg-gray-50 border-2 border-gray-300 focus:border-gray-500 focus:ring-4 focus:ring-gray-200 rounded-xl px-6 py-4 font-medium transition-all duration-300"
                  />
                </div>
              </div>

              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-3">Company/Organization</label>
                <.input
                  field={@form[:company]}
                  type="text"
                  placeholder="Your company or organization"
                  class="input-luxury w-full text-gray-900 placeholder:text-gray-500 bg-gray-50 border-2 border-gray-300 focus:border-gray-500 focus:ring-4 focus:ring-gray-200 rounded-xl px-6 py-4 font-medium transition-all duration-300"
                />
              </div>

              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-3">Purpose of Visit</label>
                <.input
                  field={@form[:purpose_of_visit]}
                  type="text"
                  placeholder="What brings you here today?"
                  class="input-luxury w-full text-gray-900 placeholder:text-gray-500 bg-gray-50 border-2 border-gray-300 focus:border-gray-500 focus:ring-4 focus:ring-gray-200 rounded-xl px-6 py-4 font-medium transition-all duration-300"
                />
              </div>

              <div class="relative">
                <label class="block text-sm font-semibold text-gray-700 mb-3">Room to Visit *</label>
                <div class="relative">
                  <.input
                    field={@form[:room_search]}
                    type="text"
                    placeholder="Type room number or name (e.g., 101, Conference A)"
                    phx-keyup="search_rooms"
                    phx-debounce="300"
                    autocomplete="off"
                    class="input-luxury w-full text-gray-900 placeholder:text-gray-500 bg-gray-50 border-2 border-gray-300 focus:border-gray-500 focus:ring-4 focus:ring-gray-200 rounded-xl px-6 py-4 font-medium transition-all duration-300"
                    required
                  />
                  <svg class="absolute right-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                  </svg>
                </div>
                
                <%= if @show_room_dropdown and @filtered_rooms != [] do %>
                  <div class="absolute z-50 w-full mt-1 bg-white border-2 border-gray-300 rounded-xl shadow-2xl max-h-60 overflow-auto">
                    <%= for room <- @filtered_rooms do %>
                      <div 
                        class="px-6 py-3 cursor-pointer hover:bg-gray-100 transition-colors duration-200 border-b border-gray-100 last:border-b-0"
                        phx-click="select_room"
                        phx-value-room-id={room.id}
                        phx-value-room-title={room.title}
                        phx-value-room-floor={room.floor}
                      >
                        <div class="font-semibold text-gray-900"><%= room.title %></div>
                        <div class="text-sm text-gray-600">Floor <%= room.floor %></div>
                      </div>
                    <% end %>
                  </div>
                <% end %>

                <%= if @show_room_dropdown and @filtered_rooms == [] and @room_search != "" do %>
                  <div class="absolute z-50 w-full mt-1 bg-white border-2 border-gray-300 rounded-xl shadow-2xl">
                    <div class="px-6 py-4 text-gray-500 text-center">
                      <svg class="w-8 h-8 mx-auto mb-2 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                      </svg>
                      No rooms found matching "<%= @room_search %>"
                    </div>
                  </div>
                <% end %>

                <!-- Hidden field to store the selected room ID -->
                <.input
                  field={@form[:room_id]}
                  type="hidden"
                />

                <%= if @selected_room do %>
                  <div class="mt-3 p-4 bg-green-50 border-2 border-green-200 rounded-xl">
                    <div class="flex items-center">
                      <svg class="w-5 h-5 text-green-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                      </svg>
                      <div>
                        <div class="font-semibold text-green-800"><%= @selected_room.title %></div>
                        <div class="text-sm text-green-700">Floor <%= @selected_room.floor %></div>
                      </div>
                    </div>
                  </div>
                <% end %>
              </div>

              <div class="flex flex-col sm:flex-row gap-6 pt-8">
                <button
                  type="submit"
                  class="btn-luxury w-full sm:flex-1 inline-flex items-center justify-center text-xl font-bold px-12 py-6 text-white shadow-2xl hover:shadow-3xl transform hover:scale-105 transition-all duration-300"
                  disabled={!@form_valid}
                >
                  <svg class="w-8 h-8 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                  </svg>
                  Complete Check-In
                </button>
                <a 
                  href="/" 
                  class="btn-platinum w-full sm:flex-1 text-center inline-flex items-center justify-center text-xl font-bold px-12 py-6 shadow-xl hover:shadow-2xl transform hover:scale-105 transition-all duration-300"
                >
                  <svg class="w-7 h-7 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                  </svg>
                  Return to Home
                </a>
              </div>
            </div>
          </.form>
        </div>

        <div class="mt-8 text-center">
          <p class="text-gray-500 text-sm">
            Need assistance? Please contact our concierge team.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    rooms = Accomodation.list_rooms()
    changeset = Persons.change_person(%Person{})

    {:ok,
     socket
     |> assign(:page_title, "Visitor Check-In")
     |> assign(:rooms, rooms)
     |> assign(:filtered_rooms, [])
     |> assign(:show_room_dropdown, false)
     |> assign(:room_search, "")
     |> assign(:selected_room, nil)
     |> assign(:form, to_form(changeset))
     |> assign(:form_valid, false)}
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset =
      %Person{}
      |> Persons.change_person(person_params)
      |> Map.put(:action, :validate)

    form_valid =
      changeset.valid? and
        present?(person_params["first_name"]) and
        present?(person_params["last_name"]) and
        present?(person_params["room_id"])

    {:noreply,
     socket
     |> assign(form: to_form(changeset))
     |> assign(:form_valid, form_valid)}
  end

  @impl true
  def handle_event("search_rooms", %{"person" => %{"room_search" => search_term}}, socket) do
    search_term = String.trim(search_term)

    filtered_rooms =
      if search_term == "" do
        []
      else
        socket.assigns.rooms
        |> Enum.filter(fn room ->
          room_display = "#{room.title} Floor #{room.floor}"
          String.contains?(String.downcase(room_display), String.downcase(search_term)) or
          String.starts_with?(String.downcase(room.title), String.downcase(search_term))
        end)
        |> Enum.take(10)
      end

    {:noreply,
     socket
     |> assign(:room_search, search_term)
     |> assign(:filtered_rooms, filtered_rooms)
     |> assign(:show_room_dropdown, search_term != "")
     |> assign(:selected_room, if search_term == "", do: nil, else: socket.assigns.selected_room)}
  end

  @impl true
  def handle_event("select_room", %{"room-id" => room_id, "room-title" => room_title, "room-floor" => room_floor}, socket) do
    selected_room = %{
      id: String.to_integer(room_id),
      title: room_title,
      floor: String.to_integer(room_floor)
    }

    changeset =
      %Person{}
      |> Persons.change_person(%{
        "room_search" => "#{selected_room.title} - Floor #{selected_room.floor}",
        "room_id" => Integer.to_string(selected_room.id)
      })

    current_params = socket.assigns.form.params || %{}
    updated_params = Map.merge(current_params, %{
      "room_search" => "#{selected_room.title} - Floor #{selected_room.floor}",
      "room_id" => Integer.to_string(selected_room.id)
    })

    form_valid =
      changeset.valid? and
        present?(updated_params["first_name"]) and
        present?(updated_params["last_name"]) and
        present?(updated_params["room_id"])

    {:noreply,
     socket
     |> assign(:show_room_dropdown, false)
     |> assign(:filtered_rooms, [])
     |> assign(:selected_room, selected_room)
     |> assign(:form, to_form(changeset, as: :person))
     |> assign(:form_valid, form_valid)}
  end

  @impl true
  def handle_event("check_in", %{"person" => person_params}, socket) do
    full_name = "#{person_params["first_name"]} #{person_params["last_name"]}"
    person_params = Map.put(person_params, "name", full_name)

    case Persons.create_person(person_params) do
      {:ok, person} ->
        case Persons.check_in_person(person, person_params["room_id"]) do
          {:ok, _person} ->
            {:noreply,
             socket
             |> put_flash(
               :info,
               "Welcome #{full_name}! You have been checked in successfully. Enjoy your visit!"
             )
             |> push_navigate(to: ~p"/visitor/check-out")}

          {:error, _changeset} ->
            {:noreply,
             socket
             |> put_flash(
               :error,
               "There was an error processing your check-in. Please try again."
             )}
        end

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp present?(value) when is_binary(value), do: String.trim(value) != ""
  defp present?(_), do: false
end
