defmodule Trackguests3Web.AdminLive.ResidenceFormComponent do
  use Trackguests3Web, :live_component

  alias Trackguests3.Accomodation

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage residence properties</:subtitle>
      </.header>

      <.form
        for={@form}
        id="residence-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-4"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:address]} type="text" label="Address" />
        <.input field={@form[:floor_count]} type="number" label="Floor count" />
        <.input 
          field={@form[:timezone]} 
          type="select" 
          label="Timezone" 
          options={@timezone_options}
          prompt="Select timezone"
        />
        
        <!-- CSV Room Upload Section -->
        <div class="border-t pt-4 mt-6">
          <h3 class="text-lg font-medium text-gray-900 mb-3">Bulk Room Import</h3>
          <p class="text-sm text-gray-600 mb-4">
            Upload a CSV file to add multiple rooms at once. CSV should have columns: title, floor, needs_fob, memo, accepts_guests
          </p>
          
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700">CSV Content</label>
              <p class="text-xs text-gray-500 mb-2">
                Paste your CSV content below or copy from Excel/spreadsheet
              </p>
              <textarea 
                name="csv_content"
                phx-target={@myself}
                phx-change="upload_csv"
                placeholder="title,floor,needs_fob,memo,accepts_guests&#10;Room 101,1,true,Corner room,true&#10;Room 102,1,false,Standard room,true"
                rows="6"
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 text-sm"
              ><%= assigns[:csv_content] %></textarea>
            </div>
            
            <%= if assigns[:csv_preview] do %>
              <div class="mt-4">
                <h4 class="text-sm font-medium text-gray-900 mb-2">Preview (First 5 rows):</h4>
                <div class="overflow-x-auto">
                  <table class="min-w-full divide-y divide-gray-200 border">
                    <thead class="bg-gray-50">
                      <tr>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Title</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Floor</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Needs FOB</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Memo</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase">Accepts Guests</th>
                      </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                      <%= for room <- Enum.take(@csv_preview, 5) do %>
                        <tr>
                          <td class="px-3 py-2 text-sm text-gray-900"><%= room["title"] %></td>
                          <td class="px-3 py-2 text-sm text-gray-900"><%= room["floor"] %></td>
                          <td class="px-3 py-2 text-sm text-gray-900"><%= room["needs_fob"] %></td>
                          <td class="px-3 py-2 text-sm text-gray-900"><%= room["memo"] %></td>
                          <td class="px-3 py-2 text-sm text-gray-900"><%= room["accepts_guests"] %></td>
                        </tr>
                      <% end %>
                    </tbody>
                  </table>
                </div>
                <p class="text-sm text-gray-500 mt-2">
                  Total rooms to import: <%= length(@csv_preview) %>
                </p>
              </div>
            <% end %>
          </div>
        </div>
        <div>
          <.button phx-disable-with="Saving...">Save Residence</.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{residence: residence} = assigns, socket) do
    changeset = Accomodation.change_residence(residence)
    timezone_options = Accomodation.get_supported_timezones()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:timezone_options, timezone_options)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"residence" => residence_params}, socket) do
    changeset =
      socket.assigns.residence
      |> Accomodation.change_residence(residence_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("upload_csv", params, socket) do
    csv_content = get_in(params, ["csv_content"]) || ""
    
    case String.trim(csv_content) do
      "" ->
        {:noreply, 
         socket
         |> assign(:csv_preview, nil)
         |> assign(:csv_content, nil)
         |> clear_flash()}
      
      content ->
        case Accomodation.parse_csv_rooms(content) do
          {:ok, room_data} ->
            {:noreply, 
             socket
             |> assign(:csv_preview, room_data)
             |> assign(:csv_content, content)
             |> put_flash(:info, "CSV parsed successfully. #{length(room_data)} rooms ready to import.")}
          
          {:error, reason} ->
            {:noreply, 
             socket
             |> assign(:csv_preview, nil)
             |> assign(:csv_content, content)
             |> put_flash(:error, "CSV parsing failed: #{reason}")}
        end
    end
  end

  def handle_event("save", %{"residence" => residence_params}, socket) do
    save_residence(socket, socket.assigns.action, residence_params)
  end

  defp save_residence(socket, :edit, residence_params) do
    case Accomodation.update_residence(socket.assigns.residence, residence_params) do
      {:ok, residence} ->
        # Process CSV import if available
        socket = process_csv_import(socket, residence)
        notify_parent({:saved, residence})

        {:noreply,
         socket
         |> put_flash(:info, "Residence updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_residence(socket, :new, residence_params) do
    case Accomodation.create_residence(residence_params) do
      {:ok, residence} ->
        # Process CSV import if available
        socket = process_csv_import(socket, residence)
        notify_parent({:saved, residence})

        {:noreply,
         socket
         |> put_flash(:info, "Residence created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp process_csv_import(socket, residence) do
    case socket.assigns[:csv_content] do
      nil ->
        socket
      
      csv_content ->
        case Accomodation.create_rooms_from_csv(residence.id, csv_content) do
          {:ok, %{created: created_count, errors: []}} ->
            socket
            |> put_flash(:info, "#{created_count} rooms imported successfully from CSV")
            |> assign(:csv_preview, nil)
            |> assign(:csv_content, nil)
          
          {:ok, %{created: created_count, errors: errors}} ->
            error_msg = "#{created_count} rooms imported, but #{length(errors)} had errors: #{Enum.join(errors, "; ")}"
            socket
            |> put_flash(:warning, error_msg)
            |> assign(:csv_preview, nil)
            |> assign(:csv_content, nil)
          
          {:error, reason} ->
            socket
            |> put_flash(:error, "CSV import failed: #{reason}")
        end
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end