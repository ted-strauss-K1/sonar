defmodule Sonar.Repo.Migrations.CreateShow do
  use Ecto.Migration

  def change do
    create table(:shows) do
      add :artist, :string
      add :venue, :string
      add :venue_lat, :float
      add :venue_long, :float
      add :price, :string
      add :utc_date, :integer
      add :ytid, :string

      timestamps()
    end

  end
end
