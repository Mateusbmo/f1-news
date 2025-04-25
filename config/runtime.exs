import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.

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
  uri = URI.parse(database_url)

  config :f1_news, F1News.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: uri.userinfo |> String.split(":") |> List.first(),
    password: uri.userinfo |> String.split(":") |> List.last(),
    database: uri.path |> String.trim_leading("/"),
    hostname: uri.host,
    port: uri.port,
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
