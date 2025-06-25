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
        <div class="page-header text-center">
          <h1 class="page-title">Visitor Check-In</h1>
          <p class="page-subtitle">Welcome! Please check in to your visit.</p>
        </div>

        <div class="card-hospitality">
          <.form for={@form} id="check-in-form" phx-change="validate" phx-submit="check_in">
            <div class="space-y-6">
              <div>
                <label class="block text-sm font-medium text-stone-700 mb-2">Your Name *</label>
                <.input
                  field={@form[:name]}
                  type="text"
                  placeholder="Enter your full name"
                  class="input-hospitality w-full"
                  required
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-stone-700 mb-2">Email</label>
                <.input
                  field={@form[:email]}
                  type="email"
                  placeholder="your.email@example.com"
                  class="input-hospitality w-full"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-stone-700 mb-2">Phone</label>
                <.input
                  field={@form[:phone]}
                  type="text"
                  placeholder="Your phone number"
                  class="input-hospitality w-full"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-stone-700 mb-2">Company/Organization</label>
                <.input
                  field={@form[:company]}
                  type="text"
                  placeholder="Your company or organization"
                  class="input-hospitality w-full"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-stone-700 mb-2">Purpose of Visit</label>
                <.input
                  field={@form[:purpose_of_visit]}
                  type="text"
                  placeholder="What brings you here today?"
                  class="input-hospitality w-full"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-stone-700 mb-2">Room to Visit *</label>
                <select name="room_id" class="input-hospitality w-full" required>
                  <option value="">Select a room...</option>
                  <%= for room <- @rooms do %>
                    <option value={room.id}>
                      <%= room.title %> - Floor <%= room.floor %>
                    </option>
                  <% end %>
                </select>
              </div>

              <div class="flex space-x-4">
                <button
                  type="submit"
                  class="btn-hospitality flex-1 inline-flex items-center justify-center"
                  disabled={!@form.source.valid?}
                >
                  <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                  </svg>
                  Check In
                </button>
                <a href="/" class="bg-stone-200 hover:bg-stone-300 text-stone-700 px-6 py-3 rounded-lg font-medium transition-colors flex-1 text-center">
                  Cancel
                </a>
              </div>
            </div>
          </.form>
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
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset =
      %Person{}
      |> Persons.change_person(person_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  @impl true
  def handle_event("check_in", %{"person" => person_params, "room_id" => room_id}, socket) do
    case Persons.create_person(person_params) do
      {:ok, person} ->
        case Persons.check_in_person(person, room_id) do
          {:ok, _person} ->
            {:noreply,
             socket
             |> put_flash(:info, "Welcome! You have been checked in successfully.")
             |> push_navigate(to: ~p"/visitor/check-out")}

          {:error, _changeset} ->
            {:noreply,
             socket
             |> put_flash(:error, "There was an error checking you in. Please try again.")}
        end

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
