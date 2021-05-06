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
    post "/batteries/attach", BatteryController, :attach

    resources "/bldgs", BldgController, except: [:new, :edit, :create], param: "address"
    resources "/batteries", BatteryController, except: [:new, :edit, :create], param: "bldg_address"
  end
end
