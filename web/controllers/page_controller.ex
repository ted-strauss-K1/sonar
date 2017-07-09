defmodule Sonar.PageController do
  use Sonar.Web, :controller

  # plug Sonar.Plug.Authenticate

  def index(conn, _params) do
    render conn, "index.html", env: Application.get_env(:sonar, :env)
  end
end
