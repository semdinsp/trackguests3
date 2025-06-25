defmodule Trackguests3Web.VisitorLive.CheckOut do
  use Trackguests3Web, :live_view

  alias Trackguests3.Persons

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-2xl mx-auto">
        <div class="page-header-luxury text-center">
          <div class="w-20 h-20 gradient-header-luxury rounded-3xl flex items-center justify-center mx-auto mb-8 shadow-luxury">
            <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
            </svg>
          </div>
          <h1 class="page-title-luxury text-platinum">Visitor Check-Out</h1>
          <p class="page-subtitle-luxury">Thank you for your visit! Please check out below.</p>
        </div>

        <div class="card-luxury">
          <%= if @checked_in_persons == [] do %>
            <div class="text-center py-20">
              <div class="w-16 h-16 bg-gray-100 rounded-2xl flex items-center justify-center mx-auto mb-6">
                <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                </svg>
              </div>
              <h3 class="text-2xl font-bold text-platinum mb-4">No Active Visitors</h3>
              <p class="text-gray-600 mb-8 text-lg">There are currently no checked-in visitors.</p>
              <a href="/visitor/check-in" class="btn-luxury inline-flex items-center">
                <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                </svg>
                Check In Instead
              </a>
            </div>
          <% else %>
            <div class="space-y-6">
              <div class="text-center mb-8">
                <h3 class="text-xl font-semibold text-platinum mb-2">Active Visitors</h3>
                <p class="text-gray-600">Select your name to complete check-out:</p>
              </div>
              
              <%= for person <- @checked_in_persons do %>
                <div class="bg-gradient-to-r from-gray-50 to-white border border-gray-200 rounded-xl p-6 hover:shadow-luxury transition-all duration-300 group">
                  <div class="flex justify-between items-center">
                    <div class="flex-1">
                      <div class="flex items-center mb-3">
                        <div class="w-12 h-12 bg-gradient-to-br from-gray-600 to-gray-800 rounded-xl flex items-center justify-center mr-4">
                          <span class="text-white font-bold text-lg"><%= String.first(person.name) %></span>
                        </div>
                        <div>
                          <h4 class="text-xl font-bold text-platinum"><%= person.name %></h4>
                          <p class="text-gray-600 font-medium">
                            <%= if person.company, do: person.company, else: "Visitor" %>
                          </p>
                        </div>
                      </div>
                      <div class="ml-16 space-y-2">
                        <div class="flex items-center text-sm text-gray-600">
                          <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 14v3m4-3v3m4-3v3M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z"/>
                          </svg>
                          Visiting: <%= if person.room, do: person.room.title, else: "Unknown Room" %>
                        </div>
                        <div class="flex items-center text-sm text-gray-500">
                          <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                          </svg>
                          Checked in: <%= Calendar.strftime(person.check_in_time, "%I:%M %p") %>
                        </div>
                        <%= if person.purpose_of_visit do %>
                          <div class="flex items-center text-sm text-gray-500">
                            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                            </svg>
                            Purpose: <%= person.purpose_of_visit %>
                          </div>
                        <% end %>
                      </div>
                    </div>
                    <button
                      phx-click="check_out"
                      phx-value-person-id={person.id}
                      class="btn-luxury inline-flex items-center ml-6 group-hover:scale-105 transition-transform"
                    >
                      <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                      </svg>
                      Check Out
                    </button>
                  </div>
                </div>
              <% end %>
            </div>
          <% end %>
        </div>
        
        <div class="mt-8 text-center">
          <a href="/" class="text-gray-500 hover:text-platinum text-sm font-medium transition-colors">
            ← Return to Home
          </a>
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
