defmodule F1News.Repo.Migrations.CreateDrivers do
  use Ecto.Migration
  def change do
    create table(:drivers) do
      add :name, :string
      add :number, :integer
      add :team_id, references(:teams)
      add :nationality, :string
      add :bio, :text
      add :image, :string
      add :debut, :integer
      add :wins, :integer
      timestamps()
    end
  end
end
