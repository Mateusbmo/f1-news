import Config

# Log immediately to confirm runtime.exs is loaded
IO.puts("Loading config/runtime.exs")

# Log the environment
IO.puts("Config environment: #{inspect(config_env())}")

# Log MIX_ENV
IO.puts("MIX_ENV: #{System.get_env("MIX_ENV")}")

# Enable server for releases
if System.get_env("PHX_SERVER") do
  config :f1_news, F1NewsWeb.Endpoint, server: true
end

# Configurações específicas para o ambiente de produção
if config_env() == :prod do
  # Log that prod config is being processed
  IO.puts("Processing prod configuration")

  # Database configuration
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: postgres://USER:PASS@HOST/DATABASE
      """

  # Log the DATABASE_URL immediately
  IO.puts("DATABASE_URL: #{database_url}")

  # Parse DATABASE_URL to extract database name
  uri = URI.parse(database_url)
  database_name = uri.path |> String.trim_leading("/") |> String.trim()

  # Log parsed URI host and database name
  IO.puts("Parsed URI host: #{uri.host}")
  IO.puts("Parsed database name: #{database_name}")

  # Configuração do repositório (banco de dados)
  config :f1_news, F1News.Repo,
    url: database_url,
    database: database_name,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: true,
    ssl_opts: [
      verify: :verify_peer,
      cacerts: :public_key.cacerts_get(),
      server_name_indication: to_charlist(uri.host || "f1-news-shy-meadow-1757-db.internal")
    ]

  # Log the Repo configuration
  IO.inspect(F1News.Repo.config(), label: "F1News.Repo Config")

  # Secret key base for cookies and secrets
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  # Configura o host e a porta do endpoint
  host = System.get_env("PHX_HOST") || "f1kiyoshi.fly.dev"
  port = String.to_integer(System.get_env("PORT") || "8080")

  # Configuração de DNS cluster
  config :f1_news, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  # Configuração do endpoint
  config :f1_news, F1NewsWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base
end
