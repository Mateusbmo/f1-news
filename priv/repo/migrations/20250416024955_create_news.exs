defmodule F1News.Repo.Migrations.CreateNews do
  use Ecto.Migration

  def change do
    create table(:news) do
      add :title, :string
      add :content, :text
      add :author, :string
      add :published_at, :utc_datetime
      add :image_url, :string

      timestamps()
    end
  end
end
