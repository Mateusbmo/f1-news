defmodule F1NewsWeb.StandingsLive do
  use F1NewsWeb, :live_view
  alias F1News.Ergast

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, standings: [], loading: true)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, load_standings(socket)}
  end

  defp load_standings(socket) do
    case Ergast.get_driver_standings() do
      {:ok, standings} ->
        assign(socket, standings: standings, loading: false)

      {:error, _reason} ->
        assign(socket, standings: [], loading: false, error: "Failed to load standings")
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto p-4">
      <h1 class="text-3xl font-bold mb-6 text-center">Driver Standings 2024</h1>

      <%= if @loading do %>
        <p class="text-center text-gray-600">Loading...</p>
      <% end %>

      <%= if assigns[:error] do %>
        <p class="text-center text-red-600"><%= @error %></p>
      <% end %>

      <%= if not @loading and @standings != [] do %>
        <div class="overflow-x-auto">
          <table class="table w-full">
            <thead>
              <tr>
                <th class="text-left">Position</th>
                <th class="text-left">Driver</th>
                <th class="text-left">Team</th>
                <th class="text-left">Points</th>
                <th class="text-left">Wins</th>
              </tr>
            </thead>
            <tbody>
              <%= for driver <- @standings do %>
                <tr class="hover">
                  <td><%= driver["position"] %></td>
                  <td>
                    <%= driver["Driver"]["givenName"] %> <%= driver["Driver"]["familyName"] %>
                  </td>
                  <td><%= List.first(driver["Constructors"])["name"] %></td>
                  <td><%= driver["points"] %></td>
                  <td><%= driver["wins"] %></td>
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
