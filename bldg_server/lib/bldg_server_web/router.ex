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
    post "/batteries/detach", BatteryController, :detach
    post "/messages/say", MessageController, :say

    resources "/bldgs", BldgController, except: [:new, :edit, :create], param: "address"
    resources "/batteries", BatteryController, except: [:new, :edit, :create], param: "bldg_address"
    resources "/messages", MessageController, except: [:new, :edit, :create]
  end
end
