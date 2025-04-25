import Config

# General application configuration
config :f1_news,
  ecto_repos: [F1News.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the repository
config :f1_news, F1News.Repo,
  adapter: Ecto.Adapters.Postgres

# Configures the endpoint
config :f1_news, F1NewsWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: F1NewsWeb.ErrorHTML, json: F1NewsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: F1News.PubSub,
  live_view: [signing_salt: "bZuBmudC"]

# Configures the mailer
config :f1_news, F1News.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild
config :esbuild,
  version: "0.17.11",
  f1_news: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind
config :tailwind,
  version: "3.4.3",
  f1_news: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config
import_config "#{config_env()}.exs"
