defmodule F1NewsWeb.ScheduleLive do
  use F1NewsWeb, :live_view
  alias F1News.Ergast

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, races: [], loading: true)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, load_schedule(socket)}
  end

  defp load_schedule(socket) do
    case Ergast.get_schedule() do
      {:ok, races} ->
        assign(socket, races: races, loading: false)

      {:error, _reason} ->
        assign(socket, races: [], loading: false, error: "Failed to load schedule")
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto p-4">
      <h1 class="text-3xl font-bold mb-6 text-center">F1 2024 Schedule</h1>

      <%= if @loading do %>
        <p class="text-center text-gray-600">Loading...</p>
      <% end %>

      <%= if assigns[:error] do %>
        <p class="text-center text-red-600"><%= @error %></p>
      <% end %>

      <%= if not @loading and @races != [] do %>
        <div class="overflow-x-auto">
          <table class="table w-full">
            <thead>
              <tr>
                <th class="text-left">Round</th>
                <th class="text-left">Race Name</th>
                <th class="text-left">Circuit</th>
                <th class="text-left">Date</th>
                <th class="text-left">Location</th>
              </tr>
            </thead>
            <tbody>
              <%= for race <- @races do %>
                <tr class="hover">
                  <td><%= race["round"] %></td>
                  <td><%= race["raceName"] %></td>
                  <td><%= race["Circuit"]["circuitName"] %></td>
                  <td><%= race["date"] %></td>
                  <td><%= race["Circuit"]["Location"]["locality"] %>, <%= race["Circuit"]["Location"]["country"] %></td>
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>
      <% end %>
    </div>
    """
  end
end
