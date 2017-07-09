defmodule Sonar.ShowTest do
  use Sonar.ModelCase

  alias Sonar.Show

  @valid_attrs %{artist: "some content", price: "some content", utc_date: 42, venue: "some content", venue_lat: "120.5", venue_long: "120.5", ytid: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Show.changeset(%Show{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Show.changeset(%Show{}, @invalid_attrs)
    refute changeset.valid?
  end
end
