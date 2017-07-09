defmodule Sonar.VenueControllerTest do
  use Sonar.ConnCase

  alias Sonar.Venue
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, venue_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    venue = Repo.insert! %Venue{}
    conn = get conn, venue_path(conn, :show, venue)
    assert json_response(conn, 200)["data"] == %{"id" => venue.id,
      "name" => venue.name}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, venue_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, venue_path(conn, :create), venue: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Venue, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, venue_path(conn, :create), venue: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    venue = Repo.insert! %Venue{}
    conn = put conn, venue_path(conn, :update, venue), venue: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Venue, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    venue = Repo.insert! %Venue{}
    conn = put conn, venue_path(conn, :update, venue), venue: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    venue = Repo.insert! %Venue{}
    conn = delete conn, venue_path(conn, :delete, venue)
    assert response(conn, 204)
    refute Repo.get(Venue, venue.id)
  end
end
