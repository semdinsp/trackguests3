defmodule Trackguests3Web.VisitorLive.CheckIn do
  use Trackguests3Web, :live_view

  alias Trackguests3.Persons
  alias Trackguests3.Persons.Person
  alias Trackguests3.Accomodation

  @impl true
  def mount(params, _session, socket) do
    residence_id = params["residence_id"]
    residence = if residence_id, do: Accomodation.get_residence!(residence_id), else: nil

    {:ok,
     socket
     |> assign(:current_scope, %{})
     |> assign(:residence, residence)
     |> assign(:person, %Person{})
     |> assign(:form, to_form(Persons.change_person(%Person{})))
     |> assign(:room_options, get_room_options(residence))
     |> assign(:page_title, "Guest Check-In")}
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset = Persons.change_person(socket.assigns.person, person_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("check_in", %{"person" => person_params}, socket) do
    case Persons.create_person(person_params) do
      {:ok, person} ->
        room_id = person_params["room_id"]

        case Persons.check_in_person(person, room_id) do
          {:ok, checked_in_person} ->
            # Broadcast real-time update
            Phoenix.PubSub.broadcast(
              Trackguests3.PubSub,
              "dashboard_updates",
              {:dashboard_update, %{}}
            )

            {:noreply,
             socket
             |> put_flash(:info, "#{person.name} successfully checked in!")
             |> assign(:person, %Person{})
             |> assign(:form, to_form(Persons.change_person(%Person{})))}

          {:error, _changeset} ->
            {:noreply,
             socket
             |> put_flash(:error, "Failed to check in guest. Please try again.")}
        end

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("select_residence", %{"residence_id" => residence_id}, socket) do
    residence = if residence_id != "", do: Accomodation.get_residence!(residence_id), else: nil
    room_options = get_room_options(residence)

    {:noreply,
     socket
     |> assign(:residence, residence)
     |> assign(:room_options, room_options)}
  end

  defp get_room_options(nil) do
    Accomodation.list_rooms()
    |> Enum.filter(& &1.accepts_guests)
    |> Enum.map(fn room ->
      residence =
        if room.residence_id, do: Accomodation.get_residence!(room.residence_id), else: nil

      residence_name = if residence, do: residence.title, else: "Unknown"
      {"#{residence_name} - #{room.title} (Floor #{room.floor})", room.id}
    end)
  end

  defp get_room_options(residence) do
    Accomodation.list_rooms()
    |> Enum.filter(fn room ->
      room.residence_id == residence.id && room.accepts_guests
    end)
    |> Enum.map(fn room ->
      {"#{room.title} (Floor #{room.floor})", room.id}
    end)
  end

  defp get_residence_options do
    Accomodation.list_residences()
    |> Enum.map(&{&1.title, &1.id})
  end
end
