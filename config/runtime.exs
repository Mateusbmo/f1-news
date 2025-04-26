import Config

# Log imediato para confirmar carregamento
IO.puts("START: Loading config/runtime.exs")
IO.puts("Config environment: #{inspect(config_env())}")
IO.puts("MIX_ENV: #{System.get_env("MIX_ENV")}")

# Configuração específica para produção
if config_env() == :prod do
  IO.puts("Applying prod configuration")

  # Banco de dados
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: postgres://USER:PASS@HOST/DATABASE
      """
  IO.puts("DATABASE_URL: #{database_url}")

  uri = URI.parse(database_url)
  database_name = uri.path |> String.trim_leading("/") |> String.trim()
  IO.puts("Parsed URI host: #{uri.host}")
  IO.puts("Parsed database name: #{database_name}")

  config :f1_news, F1News.Repo,
    url: database_url,
    database: database_name,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: true

  IO.inspect(F1News.Repo.config(), label: "F1News.Repo Config")

  # Secret key base
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  # Endpoint
  host = System.get_env("PHX_HOST") || "f1kiyoshi.fly.dev"
  port = String.to_integer(System.get_env("PORT") || "8080")

  config :f1_news, F1NewsWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}, port: port],
    secret_key_base: secret_key_base,
    server: true

  # DNS cluster
  config :f1_news, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  IO.puts("Prod configuration applied")
end

IO.puts("END: runtime.exs loaded")
