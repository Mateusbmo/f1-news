import Config

# Não coloque configurações de banco de dados aqui - elas devem estar apenas no runtime.exs

# Configurações específicas de produção
config :f1_news, F1NewsWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  code_reloader: false

config :swoosh,
  api_client: Swoosh.ApiClient.Finch,
  finch_name: F1News.Finch,
  local: false

config :logger, level: :info
