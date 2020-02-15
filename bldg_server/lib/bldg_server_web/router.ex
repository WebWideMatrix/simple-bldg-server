defmodule BldgServerWeb.Router do
  use BldgServerWeb, :router

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

  scope "/", BldgServerWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/v1", BldgServerWeb do
     pipe_through :api

     get "/look/:address", BldgController, :look
     post "/build", BldgController, :build
  end
end
