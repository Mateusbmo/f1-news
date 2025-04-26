import Config

config :f1_news, F1News.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "f1news_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :f1_news, F1NewsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  url: [host: "localhost"],
  secret_key_base: "1aFH6ybYPdzQixkz7aT0CghlN75WDl7VyhxRX6LPP8Yu5jA2dbcwCbTr/YKBs4xO2SgDF9ACg1U06l7/l+J1ag==",
  render_errors: [
    formats: [html: F1NewsWeb.ErrorHTML, json: F1NewsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: F1News.PubSub,
  live_view: [signing_salt: "p4vYcI5o"],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:f1_news, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:f1_news, ~w(--watch)]}
  ]

config :f1_news, F1News.Mailer,
  adapter: Swoosh.Adapters.Local

config :swoosh, :local, true

config :f1_news, :dev_routes, true

config :esbuild,
  version: "0.17.11",
  f1_news: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.4.3",
  f1_news: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: :debug

config :phoenix, :json_library, Jason
