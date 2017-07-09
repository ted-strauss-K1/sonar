defmodule Sonar.UserController do
  use Sonar.Web, :controller

  alias Sonar.User
  import Ecto.Query, only: [from: 2]

  plug Sonar.Plug.Authenticate
  plug Sonar.Plug.Authorize

  def index(conn, _params) do
    users = Repo.all(from u in User, preload: [:facebook_account])
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    pwd = Map.get(user_params, "password")
    changeset = User.changeset(
      %User{},
      Map.put(user_params, "password_hash", Comeonin.Bcrypt.hashpwsalt pwd)
    )

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "user.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    pwd = Map.get(user_params, "password")
    user_params = case Map.get(user_params, "password") do
      ""  -> user_params
      pwd -> Map.put(user_params, "password_hash", Comeonin.Bcrypt.hashpwsalt pwd)
    end
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
