import Config

# Configure the endpoint to listen on 0.0.0.0:8080 for Fly.io
config :f1_news, F1NewsWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  url: [host: "f1kiyoshi.fly.dev", port: 443, scheme: "https"],
  http: [ip: {0, 0, 0, 0}, port: 8080],
  server: true

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: F1News.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

# Configure your database
database_url = System.get_env("DATABASE_URL") || raise "DATABASE_URL not set"

# Parse DATABASE_URL
uri = URI.parse(database_url)

config :f1_news, F1News.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: uri.userinfo && String.split(uri.userinfo, ":") |> List.first(),
  password: uri.userinfo && String.split(uri.userinfo, ":") |> List.last(),
  database: uri.path && String.trim_leading(uri.path, "/"),
  hostname: uri.host,
  port: uri.port,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true,
  ssl_opts: [
    verify: :verify_peer,
    cacerts: :castore.cacerts()
  ]
