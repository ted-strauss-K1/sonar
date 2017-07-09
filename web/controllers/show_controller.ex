defmodule Sonar.ShowController do
  use Sonar.Web, :controller

  alias Sonar.Show

  plug Sonar.Plug.Authenticate
  plug Sonar.Plug.Authorize

  def index(conn, _params) do
    shows = Repo.all(Show)
    render(conn, "index.html", shows: shows)
  end

  def new(conn, _params) do
    changeset = Show.changeset(%Show{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"show" => show_params}) do
    changeset = Show.changeset(%Show{}, show_params)

    case Repo.insert(changeset) do
      {:ok, _show} ->
        conn
        |> put_flash(:info, "Show created successfully.")
        |> redirect(to: show_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    show = Repo.get!(Show, id)
    render(conn, "show.html", show: show)
  end

  def edit(conn, %{"id" => id}) do
    show = Repo.get!(Show, id)
    changeset = Show.changeset(show)
    render(conn, "edit.html", show: show, changeset: changeset)
  end

  def update(conn, %{"id" => id, "show" => show_params}) do
    show = Repo.get!(Show, id)
    changeset = Show.changeset(show, show_params)

    case Repo.update(changeset) do
      {:ok, show} ->
        conn
        |> put_flash(:info, "Show updated successfully.")
        |> redirect(to: show_path(conn, :show, show))
      {:error, changeset} ->
        render(conn, "edit.html", show: show, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    show = Repo.get!(Show, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(show)

    conn
    |> put_flash(:info, "Show deleted successfully.")
    |> redirect(to: show_path(conn, :index))
  end
end
