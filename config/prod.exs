import Config

# Database configuration
config :f1_news, F1News.Repo,
  url: System.get_env("DATABASE_URL") || raise("environment variable DATABASE_URL is missing"),
  database: "f1kiyoshi",
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
