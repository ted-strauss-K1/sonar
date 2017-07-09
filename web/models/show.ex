defmodule Sonar.Show do
  use Sonar.Web, :model

  schema "shows" do
    field :artist, :string
    field :venue, :string
    field :venue_lat, :float
    field :venue_long, :float
    field :price, :string
    field :utc_date, :integer
    field :ytid, :string
    field :url_facebook, :string
    field :url_ticket, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:artist, :venue, :venue_lat, :venue_long, :price, :utc_date, :ytid, :url_facebook, :url_ticket])
    |> validate_required([:artist, :venue, :venue_lat, :venue_long, :utc_date, :ytid])
  end
end
