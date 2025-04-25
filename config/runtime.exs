import Config

# Log immediately to confirm runtime.exs is loaded
IO.puts("Loading config/runtime.exs")

# Log the environment
IO.puts("Config environment: #{inspect(config_env())}")

# Log all environment variables
IO.puts("Environment variables: #{inspect(System.get_env())}")

# Enable server for releases
if System.get_env("PHX_SERVER") do
  config :f1_news, F1NewsWeb.Endpoint, server: true
end

if config_env() == :prod do
  # Log that prod config is being processed
  IO.puts("Processing prod configuration")

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
