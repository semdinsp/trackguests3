defmodule Trackguests3Web.HistoryLive.Index do
  use Trackguests3Web, :live_view

  alias Trackguests3.Persons
  alias Trackguests3.Accomodation

  @impl true
  def mount(_params, _session, socket) do
    # Default to last 30 days
    end_date = Date.utc_today()
    start_date = Date.add(end_date, -30)
    
    {:ok,
     socket
     |> assign(:start_date, start_date)
     |> assign(:end_date, end_date)
     |> assign(:history_data, [])
     |> assign(:loading, false)
     |> assign(:current_scope, socket.assigns[:current_scope])
     |> assign(:page_title, "Guest History")
     |> load_history_data()}
  end

  @impl true
  def handle_event("update_date_range", %{"start_date" => start_date, "end_date" => end_date}, socket) do
    with {:ok, start_date} <- Date.from_iso8601(start_date),
         {:ok, end_date} <- Date.from_iso8601(end_date) do
      
      # Validate date range
      if Date.compare(start_date, end_date) in [:lt, :eq] do
        {:noreply,
         socket
         |> assign(:start_date, start_date)
         |> assign(:end_date, end_date)
         |> assign(:loading, true)
         |> load_history_data()}
      else
        {:noreply,
         socket
         |> put_flash(:error, "Start date must be before or equal to end date")}
      end
    else
      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "Invalid date format")}
    end
  end

  @impl true
  def handle_event("download_csv", _params, socket) do
    start_date = socket.assigns.start_date
    end_date = socket.assigns.end_date
    
    # Create CSV download URL with date range parameters
    csv_url = "/history/export.csv?start_date=#{Date.to_iso8601(start_date)}&end_date=#{Date.to_iso8601(end_date)}"
    
    {:noreply,
     socket
     |> put_flash(:info, "Preparing CSV download...")
     |> push_event("download_csv", %{url: csv_url})}
  end

  defp load_history_data(socket) do
    start_date = socket.assigns.start_date
    end_date = socket.assigns.end_date
    
    # Convert dates to DateTime for database queries
    start_datetime = DateTime.new!(start_date, ~T[00:00:00])
    end_datetime = DateTime.new!(Date.add(end_date, 1), ~T[00:00:00])
    
    history_data = get_history_data(start_datetime, end_datetime)
    
    socket
    |> assign(:history_data, history_data)
    |> assign(:loading, false)
  end

  defp get_history_data(start_datetime, end_datetime) do
    try do
      # Get all persons (guests) within the date range
      persons = Persons.list_persons()
      
      persons
      |> Enum.filter(fn person ->
        check_in_time = person.check_in_time
        check_out_time = person.check_out_time
        
        # Include if check-in or check-out happened within the range
        (check_in_time && DateTime.compare(check_in_time, start_datetime) != :lt && 
         DateTime.compare(check_in_time, end_datetime) == :lt) ||
        (check_out_time && DateTime.compare(check_out_time, start_datetime) != :lt && 
         DateTime.compare(check_out_time, end_datetime) == :lt)
      end)
      |> Enum.map(fn person ->
        # Get room and residence information
        room_info = if person.room_id do
          case Accomodation.get_room(person.room_id) do
            {:error, :not_found} -> {nil, nil}
            {:ok, room} ->
              residence = if room.residence_id do
                try do
                  Accomodation.get_residence!(room.residence_id)
                rescue
                  _ -> nil
                end
              else
                nil
              end
              {room, residence}
          end
        else
          {nil, nil}
        end
        
        {room, residence} = room_info
        
        %{
          id: person.id,
          name: person.name,
          email: person.email,
          phone: person.phone,
          company: person.company,
          visitor_type: person.visitor_type,
          purpose_of_visit: person.purpose_of_visit,
          room_title: if(room, do: room.title, else: "Unknown"),
          room_floor: if(room, do: room.floor, else: nil),
          residence_title: if(residence, do: residence.title, else: "Unknown"),
          check_in_time: person.check_in_time,
          check_out_time: person.check_out_time,
          status: person.status,
          fob: person.fob,
          memo: person.memo,
          inserted_at: person.inserted_at
        }
      end)
      |> Enum.sort_by(& &1.check_in_time, {:desc, DateTime})
    rescue
      _ -> []
    end
  end

  defp format_datetime(nil), do: "-"
  defp format_datetime(datetime) do
    datetime
    |> DateTime.shift_zone!("Etc/UTC")
    |> Calendar.strftime("%Y-%m-%d %H:%M UTC")
  end

  defp format_date(date) do
    Calendar.strftime(date, "%Y-%m-%d")
  end

  defp days_in_range(start_date, end_date) do
    Date.diff(end_date, start_date) + 1
  end
end