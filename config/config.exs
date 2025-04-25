import Config

# General application configuration
config :f1_news,
  ecto_repos: [F1News.Repo],
  generators: [timestamp_type: :utc_datetime]

# Basic Repo configuration
config :f1_news, F1News.Repo,
  adapter: Ecto.Adapters.Postgres

# Endpoint configuration
config :f1_news, F1NewsWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: F1NewsWeb.ErrorHTML, json: F1NewsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: F1News.PubSub,
  live_view: [signing_salt: System.get_env("SIGNING_SALT") || "bZuBmudC"]

# Mailer configuration
config :f1_news, F1News.Mailer,
  adapter: Swoosh.Adapters.Local

# Esbuild configuration
config :esbuild,
  version: "0.17.11",
  default: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Tailwind configuration
config :tailwind,
  version: "3.4.3",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Logger configuration
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Jason configuration
config :phoenix, :json_library, Jason

# Import environment specific config
case config_env() do
  :prod -> import_config "prod.exs"
  :dev -> import_config "dev.exs"
end

# Always import runtime.exs if it exists
if File.exists?("config/runtime.exs") do
  import_config "runtime.exs"
end
