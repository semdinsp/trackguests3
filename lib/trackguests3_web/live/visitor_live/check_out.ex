defmodule Trackguests3Web.VisitorLive.CheckOut do
  use Trackguests3Web, :live_view

  alias Trackguests3.Persons

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-2xl mx-auto">
        <div class="page-header text-center">
          <h1 class="page-title">Visitor Check-Out</h1>
          <p class="page-subtitle">Thank you for your visit! Please check out below.</p>
        </div>

        <div class="card-hospitality">
          <%= if @checked_in_persons == [] do %>
            <div class="text-center py-12">
              <svg class="w-16 h-16 text-stone-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
              </svg>
              <h3 class="text-lg font-medium text-stone-400 mb-2">No Active Visitors</h3>
              <p class="text-stone-400 mb-6">There are currently no checked-in visitors.</p>
              <a href="/visitor/check-in" class="btn-hospitality">Check In Instead</a>
            </div>
          <% else %>
            <div class="space-y-4">
              <p class="text-stone-600 mb-6">Select your name to check out:</p>
              
              <%= for person <- @checked_in_persons do %>
                <div class="border border-stone-200 rounded-lg p-4 hover:bg-stone-50 transition-colors">
                  <div class="flex justify-between items-center">
                    <div>
                      <h3 class="font-medium text-stone-800"><%= person.name %></h3>
                      <p class="text-sm text-stone-600">
                        Visiting: <%= if person.room, do: person.room.title, else: "Unknown Room" %>
                      </p>
                      <p class="text-sm text-stone-500">
                        Checked in: <%= Calendar.strftime(person.check_in_time, "%I:%M %p") %>
                      </p>
                    </div>
                    <button
                      phx-click="check_out"
                      phx-value-person-id={person.id}
                      class="bg-emerald-600 hover:bg-emerald-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors"
                    >
                      Check Out
                    </button>
                  </div>
                </div>
              <% end %>
            </div>
          <% end %>
        </div>
        
        <div class="mt-6 text-center">
          <a href="/" class="text-stone-600 hover:text-emerald-600 text-sm">← Back to Home</a>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    checked_in_persons = Persons.list_checked_in_persons() |> Enum.map(&preload_room/1)

    {:ok,
     socket
     |> assign(:page_title, "Visitor Check-Out")
     |> assign(:checked_in_persons, checked_in_persons)}
  end

  @impl true
  def handle_event("check_out", %{"person-id" => person_id}, socket) do
    person = Persons.get_person!(person_id)

    case Persons.check_out_person(person) do
      {:ok, _person} ->
        checked_in_persons = Persons.list_checked_in_persons() |> Enum.map(&preload_room/1)

        {:noreply,
         socket
         |> put_flash(:info, "Thank you! You have been checked out successfully.")
         |> assign(:checked_in_persons, checked_in_persons)}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, "There was an error checking you out. Please try again.")}
    end
  end

  defp preload_room(person) do
    if person.room_id do
      %{person | room: Trackguests3.Accomodation.get_rooms!(person.room_id)}
    else
      %{person | room: nil}
    end
  end
end
