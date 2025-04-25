import Config

# Configurações específicas de produção
config :f1_news, F1NewsWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  code_reloader: false

# Configuração do Swoosh para produção
config :swoosh,
  api_client: Swoosh.ApiClient.Finch,
  finch_name: F1News.Finch

# Configuração do Logger para produção
config :logger, level: :info

# Desabilita o Swoosh local em produção
config :swoosh, :local, false
