import Config

# Config static file cache
config :f1_news, F1NewsWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  code_reloader: false

# Config Swoosh
config :swoosh,
  api_client: Swoosh.ApiClient.Finch,
  finch_name: F1News.Finch,
  local: false

# Config Logger
config :logger, level: :info

# Disable dev routes in production
config :f1_news, :dev_routes, false

# Disable debug and live reload in production
config :phoenix, :debug_errors, false
config :phoenix, :code_reloader, false
