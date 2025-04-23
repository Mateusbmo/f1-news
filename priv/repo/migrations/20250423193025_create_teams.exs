defmodule F1News.Repo.Migrations.CreateTeams do
  use Ecto.Migration
  def change do
    create table(:teams) do
      add :name, :string
      add :logo, :string
      add :history, :text
      add :car_image, :string
      add :founded, :integer
      add :championships, :integer
      timestamps()
    end
  end
end
