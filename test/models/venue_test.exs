defmodule Sonar.VenueTest do
  use Sonar.ModelCase

  alias Sonar.Venue

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Venue.changeset(%Venue{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Venue.changeset(%Venue{}, @invalid_attrs)
    refute changeset.valid?
  end
end
