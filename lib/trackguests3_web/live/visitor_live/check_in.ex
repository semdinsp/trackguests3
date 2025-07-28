defmodule Trackguests3Web.VisitorLive.CheckIn do
  use Trackguests3Web, :live_view

  alias Trackguests3.Persons
  alias Trackguests3.Persons.Person
  alias Trackguests3.Accomodation
  alias Trackguests3.Accounts

  @impl true
  def mount(params, session, socket) do
    residence_id = params["residence_id"]
    
    # Get user's property if they're authenticated (this is optional for public check-in)
    {user_residence, available_locales} = try do
      case socket.assigns[:current_scope] do
        nil -> 
          # No authenticated user, use default locales
          {nil, ["en", "es", "fr"]}
        scope when is_map(scope) ->
          case Map.get(scope, :user) do
            nil -> 
              {nil, ["en", "es", "fr"]}
            user when is_map(user) ->
              user_id = Map.get(user, :id) || user.id
              user = Accounts.get_user_with_property!(user_id)
              locales = user.locales_to_show_guests || ["en"]
              {user.property, locales}
            user ->
              user = Accounts.get_user_with_property!(user.id)
              locales = user.locales_to_show_guests || ["en"]
              {user.property, locales}
          end
      end
    rescue
      _ -> {nil, ["en", "es", "fr"]}
    end
    
    # Use URL residence_id, user's property, or nil in that order of priority
    residence = cond do
      residence_id -> Accomodation.get_residence!(residence_id)
      user_residence -> user_residence
      true -> nil
    end

    # Get current locale from session or default to first available
    current_locale = session["locale"] || List.first(available_locales) || "en"
    
    # Set the gettext locale
    Gettext.put_locale(Trackguests3Web.Gettext, current_locale)

    {:ok,
     socket
     |> assign(:residence, residence)
     |> assign(:user_residence, user_residence)
     |> assign(:person, %Person{})
     |> assign(:form, to_form(Persons.change_person(%Person{})))
     |> assign(:room_options, get_room_options(residence))
     |> assign(:residence_options, get_residence_options(user_residence))
     |> assign(:room_search_results, [])
     |> assign(:selected_room_id, nil)
     |> assign(:selected_room_display, "")
     |> assign(:current_scope, socket.assigns[:current_scope])
     |> assign(:current_locale, current_locale)
     |> assign(:available_locales, available_locales)
     |> assign(:language_dropdown_open, false)
     |> assign(:page_title, "Guest Check-In")}
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset = Persons.change_person(socket.assigns.person, person_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("check_in", %{"person" => person_params}, socket) do
    require Logger
    
    # Use selected room ID from autocomplete or fallback to form room_id
    room_id = socket.assigns.selected_room_id || person_params["room_id"]
    
    if room_id && room_id != "" do
      # Add check-in data to person params
      enhanced_params = Map.merge(person_params, %{
        "room_id" => room_id,
        "check_in_time" => DateTime.utc_now(),
        "status" => "checked_in"
      })

      case Persons.create_person(enhanced_params) do
        {:ok, person} ->
          Logger.info("Guest check-in successful: #{person.name} (ID: #{person.id}) checked into room #{room_id}")
          
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
           |> assign(:form, to_form(Persons.change_person(%Person{})))
           |> assign(:selected_room_id, nil)
           |> assign(:selected_room_display, "")
           |> assign(:room_search_results, [])}

        {:error, changeset} ->
          Logger.error("Guest check-in failed: #{inspect(changeset.errors)}")
          {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
      end
    else
      Logger.warning("Check-in attempt without room selection")
      {:noreply,
       socket
       |> put_flash(:error, "Please select a room before checking in.")}
    end
  end

  def handle_event("select_residence", %{"residence_id" => residence_id}, socket) do
    residence = if residence_id != "", do: Accomodation.get_residence!(residence_id), else: nil
    room_options = get_room_options(residence)

    {:noreply,
     socket
     |> assign(:residence, residence)
     |> assign(:room_options, room_options)
     |> assign(:residence_options, get_residence_options(socket.assigns.user_residence))}
  end

  def handle_event("search_rooms", %{"value" => query}, socket) when byte_size(query) >= 2 do
    matching_rooms = search_rooms(query, socket.assigns.residence)
    {:noreply, assign(socket, :room_search_results, matching_rooms)}
  end

  def handle_event("search_rooms", %{"value" => _query}, socket) do
    {:noreply, assign(socket, :room_search_results, [])}
  end

  def handle_event("select_room", %{"room_id" => room_id, "room_display" => room_display}, socket) do
    {:noreply, 
     socket
     |> assign(:selected_room_id, room_id)
     |> assign(:selected_room_display, room_display)
     |> assign(:room_search_results, [])}
  end

  def handle_event("toggle_language_dropdown", _params, socket) do
    {:noreply, assign(socket, :language_dropdown_open, !socket.assigns.language_dropdown_open)}
  end

  def handle_event("close_language_dropdown", _params, socket) do
    {:noreply, assign(socket, :language_dropdown_open, false)}
  end

  def handle_event("change_language", %{"locale" => locale}, socket) do
    # Set the gettext locale
    Gettext.put_locale(Trackguests3Web.Gettext, locale)
    
    {:noreply,
     socket
     |> assign(:current_locale, locale)
     |> assign(:language_dropdown_open, false)
     |> put_flash(:info, gettext("Language changed successfully!"))}
  end

  defp get_room_options(nil) do
    try do
      all_rooms = Accomodation.list_rooms()
      
      all_rooms
      |> Enum.filter(& &1.accepts_guests)
      |> Enum.map(fn room ->
        residence = try do
          if room.residence_id, do: Accomodation.get_residence!(room.residence_id), else: nil
        rescue
          _ -> nil
        end

        residence_name = if residence, do: residence.title, else: "Unknown"
        {"#{residence_name} - #{room.title} (Floor #{room.floor})", room.id}
      end)
    rescue
      _ -> []
    end
  end

  defp get_room_options(residence) do
    try do
      all_rooms = Accomodation.list_rooms()
      
      all_rooms
      |> Enum.filter(fn room ->
        room.residence_id == residence.id && room.accepts_guests
      end)
      |> Enum.map(fn room ->
        {"#{room.title} (Floor #{room.floor})", room.id}
      end)
    rescue
      _ -> []
    end
  end

  defp get_residence_options(user_residence) do
    try do
      all_residences = Accomodation.list_residences()
      
      if user_residence do
        # Put user's property first with indicator
        user_option = {"#{user_residence.title} (Your Property)", user_residence.id}
        other_options = all_residences
                       |> Enum.reject(&(&1.id == user_residence.id))
                       |> Enum.map(&{&1.title, &1.id})
        
        [user_option | other_options]
      else
        all_residences |> Enum.map(&{&1.title, &1.id})
      end
    rescue
      _ -> []
    end
  end

  defp search_rooms(query, residence) do
    query_lower = String.downcase(query)
    
    try do
      all_rooms = Accomodation.list_rooms()
      
      rooms = if residence do
        # Filter to current residence only
        Enum.filter(all_rooms, &(&1.residence_id == residence.id && &1.accepts_guests))
      else
        # Search all rooms
        Enum.filter(all_rooms, & &1.accepts_guests)
      end
      
      rooms
      |> Enum.filter(fn room ->
        room_title = String.downcase(room.title)
        floor_text = "floor #{room.floor}" |> String.downcase()
        
        # Get residence name for global search
        residence_name = if residence do
          residence.title
        else
          try do
            if room.residence_id do
              res = Accomodation.get_residence!(room.residence_id)
              res.title
            else
              "Unknown"
            end
          rescue
            _ -> "Unknown"
          end
        end |> String.downcase()
        
        # Match on room title, floor, or residence name
        String.contains?(room_title, query_lower) ||
        String.contains?(floor_text, query_lower) ||
        String.contains?(residence_name, query_lower)
      end)
      |> Enum.map(fn room ->
        residence_name = if residence do
          residence.title
        else
          try do
            if room.residence_id do
              res = Accomodation.get_residence!(room.residence_id)
              res.title
            else
              "Unknown"
            end
          rescue
            _ -> "Unknown"
          end
        end
        
        display_text = if residence do
          "#{room.title} (Floor #{room.floor})"
        else
          "#{residence_name} - #{room.title} (Floor #{room.floor})"
        end
        
        %{id: room.id, display: display_text}
      end)
      |> Enum.take(10) # Limit results
    rescue
      _ -> []
    end
  end
end
