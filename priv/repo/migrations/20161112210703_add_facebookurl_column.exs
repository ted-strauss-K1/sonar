defmodule Sonar.Repo.Migrations.AddFacebookurlColumn do
  use Ecto.Migration

  def change do
    alter table(:shows) do
      add :url_facebook, :string
    end
  end
end
