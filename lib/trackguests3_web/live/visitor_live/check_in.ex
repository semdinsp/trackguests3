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

              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-3">Room to Visit *</label>
                <.input
                  field={@form[:room_id]}
                  type="select"
                  options={[{"Select a room...", ""} | Enum.map(@rooms, &{&1.title <> " - Floor #{&1.floor}", &1.id})]}
                  class="input-luxury w-full text-gray-900 bg-gray-50 border-2 border-gray-300 focus:border-gray-500 focus:ring-4 focus:ring-gray-200 rounded-xl px-6 py-4 font-medium transition-all duration-300"
                  required
                />
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
     |> assign(:form, to_form(changeset))
     |> assign(:form_valid, false)}
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset =
      %Person{}
      |> Persons.change_person(person_params)
      |> Map.put(:action, :validate)

    # Check if required fields are present and valid
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
  def handle_event("check_in", %{"person" => person_params}, socket) do
    # Combine first and last name into full name
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
