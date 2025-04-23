defmodule F1NewsWeb.ResultsLive do
  use F1NewsWeb, :live_view
  alias F1News.Ergast

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, results: [], loading: true)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, load_results(socket)}
  end

  defp load_results(socket) do
    case Ergast.get_race_results() do
      {:ok, results} ->
        assign(socket, results: results, loading: false)

      {:error, _reason} ->
        assign(socket, results: [], loading: false, error: "Failed to load results")
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto p-4">
      <h1 class="text-3xl font-bold mb-6 text-center">Latest Race Results 2024</h1>

      <%= if @loading do %>
        <p class="text-center text-gray-600">Loading...</p>
      <% end %>

      <%= if assigns[:error] do %>
        <p class="text-center text-red-600"><%= @error %></p>
      <% end %>

      <%= if not @loading and @results != [] do %>
        <div class="overflow-x-auto">
          <table class="table w-full">
            <thead>
              <tr>
                <th class="text-left">Position</th>
                <th class="text-left">Driver</th>
                <th class="text-left">Team</th>
                <th class="text-left">Time</th>
                <th class="text-left">Points</th>
              </tr>
            </thead>
            <tbody>
              <%= for result <- @results do %>
                <tr class="hover">
                  <td><%= result["position"] %></td>
                  <td>
                    <%= result["Driver"]["givenName"] %> <%= result["Driver"]["familyName"] %>
                  </td>
                  <td><%= result["Constructor"]["name"] %></td>
                  <td><%= result["Time"]["time"] || "DNF" %></td>
                  <td><%= result["points"] %></td>
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
