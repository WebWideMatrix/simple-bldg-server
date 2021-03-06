defmodule BldgServerWeb.Router do
  use BldgServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v1", BldgServerWeb do
    pipe_through :api

    get "/bldgs/resolve_address", BldgController, :resolve_address
    get "/bldgs/look/:flr", BldgController, :look
    post "/bldgs/build", BldgController, :build
    post "/bldgs/:address/relocate_to/:new_address", BldgController, :relocate

    resources "/bldgs", BldgController, except: [:new, :edit], param: "address"
  end
end
