defmodule Sonar.ScraperController do
  use Sonar.Web, :controller

  # plug Sonar.Plug.Authenticate

  def index(conn, _params) do
    Task.start(&Scraper.update/0)
    render(conn, "index.json")
  end
end
