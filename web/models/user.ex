defmodule Sonar.User do
  use Sonar.Web, :model
  alias Sonar.FacebookAccount

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :display_name, :string
    field :avatar, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :admin, :boolean
    has_one :facebook_account, FacebookAccount

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :display_name, :email, :avatar, :password_hash, :admin])
    |> validate_required([:email])
  end
end
