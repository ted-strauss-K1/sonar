defmodule Sonar.Plug.Authorize do
  import Plug.Conn
  import Sonar.Router.Helpers
  import Phoenix.Controller

  alias Sonar.User

  def init(default), do: default

  def call(conn, default) do
    id = get_session(conn, :current_user)
    user = Sonar.Repo.get!(User, id)
    if user.admin do
      conn
    else
      conn
        |> put_flash(:error, "Forbidden")
        |> redirect(to: session_path(conn, :new))
        |> halt
    end
  end
end
