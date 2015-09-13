defmodule Shortme.Router do
  use Shortme.Web, :router

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

  scope "/", Shortme do
    pipe_through :browser # Use the default browser stack

    post "/", PageController, :create
    resources "/", PageController, only: [:index, :show]
  end
end
