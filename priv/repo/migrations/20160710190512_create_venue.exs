defmodule Sonar.Repo.Migrations.CreateVenue do
  use Ecto.Migration

  def change do
    create table(:venues) do
      add :name, :string

      timestamps()
    end

  end
end
