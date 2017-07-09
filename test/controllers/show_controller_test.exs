defmodule Sonar.ShowControllerTest do
  use Sonar.ConnCase

  alias Sonar.Show
  @valid_attrs %{artist: "some content", price: "some content", utc_date: 42, venue: "some content", venue_lat: "120.5", venue_long: "120.5", ytid: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, show_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing shows"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, show_path(conn, :new)
    assert html_response(conn, 200) =~ "New show"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, show_path(conn, :create), show: @valid_attrs
    assert redirected_to(conn) == show_path(conn, :index)
    assert Repo.get_by(Show, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, show_path(conn, :create), show: @invalid_attrs
    assert html_response(conn, 200) =~ "New show"
  end

  test "shows chosen resource", %{conn: conn} do
    show = Repo.insert! %Show{}
    conn = get conn, show_path(conn, :show, show)
    assert html_response(conn, 200) =~ "Show show"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, show_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    show = Repo.insert! %Show{}
    conn = get conn, show_path(conn, :edit, show)
    assert html_response(conn, 200) =~ "Edit show"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    show = Repo.insert! %Show{}
    conn = put conn, show_path(conn, :update, show), show: @valid_attrs
    assert redirected_to(conn) == show_path(conn, :show, show)
    assert Repo.get_by(Show, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    show = Repo.insert! %Show{}
    conn = put conn, show_path(conn, :update, show), show: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit show"
  end

  test "deletes chosen resource", %{conn: conn} do
    show = Repo.insert! %Show{}
    conn = delete conn, show_path(conn, :delete, show)
    assert redirected_to(conn) == show_path(conn, :index)
    refute Repo.get(Show, show.id)
  end
end
