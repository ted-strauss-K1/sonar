defmodule Sonar.Repo.Migrations.AddTicketUrl do
  use Ecto.Migration

  def change do
    alter table(:shows) do
      add :url_ticket, :string
    end
  end
end
