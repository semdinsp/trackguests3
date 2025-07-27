defmodule Trackguests3Web.HistoryController do
  use Trackguests3Web, :controller

  alias Trackguests3.Persons
  alias Trackguests3.Accomodation

  def export_csv(conn, params) do
    # Get date range from params or use defaults
    {start_date, end_date} = get_date_range(params)
    
    # Convert dates to DateTime for database queries
    start_datetime = DateTime.new!(start_date, ~T[00:00:00])
    end_datetime = DateTime.new!(Date.add(end_date, 1), ~T[00:00:00])
    
    # Get history data
    history_data = get_history_data(start_datetime, end_datetime)
    
    # Generate CSV content
    csv_content = generate_csv(history_data)
    
    # Set up the response
    filename = "guest_history_#{Date.to_iso8601(start_date)}_to_#{Date.to_iso8601(end_date)}.csv"
    
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"#{filename}\"")
    |> send_resp(200, csv_content)
  end

  defp get_date_range(params) do
    start_date = case params["start_date"] do
      nil -> Date.add(Date.utc_today(), -30)
      date_string -> 
        case Date.from_iso8601(date_string) do
          {:ok, date} -> date
          {:error, _} -> Date.add(Date.utc_today(), -30)
        end
    end
    
    end_date = case params["end_date"] do
      nil -> Date.utc_today()
      date_string ->
        case Date.from_iso8601(date_string) do
          {:ok, date} -> date
          {:error, _} -> Date.utc_today()
        end
    end
    
    {start_date, end_date}
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
          name: person.name || "",
          email: person.email || "",
          phone: person.phone || "",
          company: person.company || "",
          visitor_type: person.visitor_type || "",
          purpose_of_visit: person.purpose_of_visit || "",
          room_title: if(room, do: room.title, else: ""),
          room_floor: if(room, do: room.floor, else: ""),
          residence_title: if(residence, do: residence.title, else: ""),
          check_in_time: format_datetime_for_csv(person.check_in_time),
          check_out_time: format_datetime_for_csv(person.check_out_time),
          status: person.status || "",
          fob: person.fob || "",
          memo: person.memo || ""
        }
      end)
      |> Enum.sort_by(& &1.check_in_time, :desc)
    rescue
      _ -> []
    end
  end

  defp format_datetime_for_csv(nil), do: ""
  defp format_datetime_for_csv(datetime) do
    datetime
    |> DateTime.shift_zone!("Etc/UTC")
    |> Calendar.strftime("%Y-%m-%d %H:%M:%S UTC")
  end

  defp generate_csv(history_data) do
    headers = [
      "Name",
      "Email", 
      "Phone",
      "Company",
      "Visitor Type",
      "Purpose of Visit",
      "Room",
      "Floor",
      "Residence",
      "Check In Time",
      "Check Out Time", 
      "Status",
      "Fob",
      "Memo"
    ]
    
    # Create CSV content
    csv_headers = Enum.join(headers, ",") <> "\n"
    
    csv_rows = Enum.map(history_data, fn record ->
      [
        escape_csv_field(record.name),
        escape_csv_field(record.email),
        escape_csv_field(record.phone),
        escape_csv_field(record.company),
        escape_csv_field(record.visitor_type),
        escape_csv_field(record.purpose_of_visit),
        escape_csv_field(record.room_title),
        escape_csv_field(to_string(record.room_floor)),
        escape_csv_field(record.residence_title),
        escape_csv_field(record.check_in_time),
        escape_csv_field(record.check_out_time),
        escape_csv_field(record.status),
        escape_csv_field(record.fob),
        escape_csv_field(record.memo)
      ]
      |> Enum.join(",")
    end)
    
    csv_headers <> Enum.join(csv_rows, "\n")
  end

  defp escape_csv_field(field) do
    field_str = to_string(field)
    
    # If the field contains comma, newline, or quote, wrap in quotes and escape quotes
    if String.contains?(field_str, [",", "\n", "\r", "\""]) do
      escaped = String.replace(field_str, "\"", "\"\"")
      "\"#{escaped}\""
    else
      field_str
    end
  end
end