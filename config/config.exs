import Config

# General application configuration
config :f1_news,
  ecto_repos: [F1News.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configuração básica do Repo
config :f1_news, F1News.Repo,
  adapter: Ecto.Adapters.Postgres

# Configuração básica do Endpoint
config :f1_news, F1NewsWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: F1NewsWeb.ErrorHTML, json: F1NewsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: F1News.PubSub,
  live_view: [signing_salt: "bZuBmudC"]

# Configurações comuns a todos os ambientes
config :f1_news, F1News.Mailer,
  adapter: Swoosh.Adapters.Local

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Import environment specific config (only if file exists)
if File.exists?("config/#{config_env()}.exs") do
  import_config "#{config_env()}.exs"
end

# Import runtime.exs if it exists
if File.exists?("config/runtime.exs") do
  import_config "runtime.exs"
end
