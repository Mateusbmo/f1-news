defmodule F1News.Repo do
  use Ecto.Repo,
    otp_app: :f1_news,
    adapter: Ecto.Adapters.Postgres
end
