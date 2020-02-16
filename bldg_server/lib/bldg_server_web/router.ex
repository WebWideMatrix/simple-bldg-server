defmodule BldgServerWeb.Router do
  use BldgServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v1", BldgServerWeb do
    pipe_through :api

    get "/look/:flr", BldgController, :look
    resources "/bldgs", BldgController, except: [:new, :edit]
  end
end
