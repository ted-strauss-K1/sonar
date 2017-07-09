defmodule Sonar.FacebookAccount do
  use Sonar.Web, :model
  alias Sonar.User

  schema "facebook_accounts" do
    belongs_to :user, User
    field      :facebook_id, :string
    field      :facebook_email, :string

    timestamps()
  end
end
