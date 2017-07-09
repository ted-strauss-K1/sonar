defmodule Sonar.Repo.Migrations.AddFacebookAccountTable do
  use Ecto.Migration

  def change do
    create table(:facebook_accounts) do
      add :user_id,        references(:users), primary_key: true
      add :facebook_id,    :string
      add :facebook_email, :string

      timestamps
    end
  end
end
