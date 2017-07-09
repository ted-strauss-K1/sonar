defmodule Sonar.SessionController do
  use Sonar.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

#   def create(conn, %{"session" => session_params}) do
#     with %{"email" => "admin", "password" => "*admin*"} <- session_params do
#       conn
#       |> put_session(:current_user, 0)
#       |> put_flash(:info, "Logged in")
#       |> redirect(to: "/")
#     else
#       _ ->
#         conn
#         |> put_flash(:info, "Wrong email or password")
#         |> render("new.html")
#     end
#   end
# end

  def create(conn, %{"session" => session_params}) do
    case Sonar.Session.login(session_params, Sonar.Repo) do
    {:ok, user} ->
      conn
      |> put_session(:current_user, user.id)
      |> put_flash(:info, "Logged in")
      |> redirect(to: "/")
    :error ->
      conn
      |> put_flash(:info, "Wrong email or password")
      |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Plug.Conn.configure_session(drop: true)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
end
