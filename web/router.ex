defmodule Sonar.Router do
  use Sonar.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Sonar do
    pipe_through :api

    get "/events/:id", ShowApiController, :index
    post "/shows_prox", ShowApiController, :shows_prox
    get "/scrape", ScraperController, :index
  end

  scope "/auth", Sonar do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end

  scope "/", Sonar do
    pipe_through :browser # Use the default browser stack

    get "/*path", PageController, :index
    resources "/users", UserController
    resources "/shows", ShowController
    resources "/venues", VenueController
    get "/login", SessionController, :new
    post "/login",  SessionController, :create
    delete "/logout", SessionController, :delete
  end
end
