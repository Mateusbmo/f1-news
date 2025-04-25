import Config

# Database configuration with fallback
database_url = System.get_env("DATABASE_URL") || "ecto://localhost/f1_news_prod"
uri = URI.parse(database_url)
database_name = uri.path |> String.trim_leading("/") |> String.trim() || "f1_news_prod"

config :f1_news, F1News.Repo,
  url: database_url,
  database: database_name,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true,
  ssl_opts: [
    verify: :verify_peer,
    cacerts: :castore.cacerts()
  ]

# Cache static assets in production
config :f1_news, F1NewsWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: F1News.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info
