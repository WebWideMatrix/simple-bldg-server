defmodule BldgServerWeb.Router do
  use BldgServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v1", BldgServerWeb do
    pipe_through :api

    get "/bldgs/look/:flr", BldgController, :look
    post "/bldgs/build", BldgController, :build

    resources "/bldgs", BldgController, except: [:new, :edit], param: "address"
  end
end
