import Config

# Enable server for releases
if System.get_env("PHX_SERVER") do
  config :f1_news, F1NewsWeb.Endpoint, server: true
end

if config_env() == :prod do
  # Database configuration
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  # Validar e parsear a DATABASE_URL
  uri = URI.parse(database_url)
  database =
    if uri.path && uri.path != "/" do
      uri.path |> String.trim_leading("/")
    else
      raise """
      DATABASE_URL is invalid: missing database name in path.
      Got: #{database_url}
      Expected: ecto://USER:PASS@HOST/DATABASE
      """
    end

  config :f1_news, F1News.Repo,
    url: database_url,
    database: database,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: true,
    ssl_opts: [
      verify: :verify_peer,
      cacerts: :castore.cacerts()
    ]

  # Secret key base for cookies and secrets
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "f1kiyoshi.fly.dev"
  port = String.to_integer(System.get_env("PORT") || "8080")

  config :f1_news, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :f1_news, F1NewsWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base
end
