defmodule F1News.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      F1NewsWeb.Telemetry,
      F1News.Repo,
      {DNSCluster, query: Application.get_env(:f1_news, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: F1News.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: F1News.Finch},
      # Start a worker by calling: F1News.Worker.start_link(arg)
      # {F1News.Worker, arg},
      # Start to serve requests, typically the last entry
      F1NewsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: F1News.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    F1NewsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
