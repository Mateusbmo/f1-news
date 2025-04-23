defmodule F1News.Ergast do
  alias HTTPoison
  alias Jason

  @base_url "http://ergast.com/api/f1"

  def get_driver_standings(season \\ "2024") do
    url = "#{@base_url}/#{season}/driverStandings.json"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"MRData" => %{"StandingsTable" => %{"StandingsLists" => [standings | _]}}}} ->
            {:ok, standings["DriverStandings"]}
          {:ok, _} ->
            {:error, :no_standings_found}
          {:error, reason} ->
            {:error, {:json_decode, reason}}
        end

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, {:http_error, code}}

      {:error, reason} ->
        {:error, {:http_error, reason}}
    end
  end

  def get_schedule(season \\ "2024") do
    url = "#{@base_url}/#{season}.json"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"MRData" => %{"RaceTable" => %{"Races" => races}}}} ->
            {:ok, races}
          {:ok, _} ->
            {:error, :no_races_found}
          {:error, reason} ->
            {:error, {:json_decode, reason}}
        end

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, {:http_error, code}}

      {:error, reason} ->
        {:error, {:http_error, reason}}
    end
  end

  def get_race_results(season \\ "2024", round \\ "last") do
    url = "#{@base_url}/#{season}/#{round}/results.json"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"MRData" => %{"RaceTable" => %{"Races" => [race | _]}}}} ->
            {:ok, race["Results"]}
          {:ok, _} ->
            {:error, :no_results_found}
          {:error, reason} ->
            {:error, {:json_decode, reason}}
        end

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, {:http_error, code}}

      {:error, reason} ->
        {:error, {:http_error, reason}}
    end
  end
end
