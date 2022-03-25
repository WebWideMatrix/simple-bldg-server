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
    post "/residents/login", ResidentController, :login
    get "/residents/verify", ResidentController, :verify_email
    get "/residents/verification_status", ResidentController, :verification_status
    get "/residents/look/:flr", ResidentController, :look
    post "/residents/act", ResidentController, :act
    get "/roads/look/:flr", RoadController, :look
    
    resources "/bldgs", BldgController, except: [:new, :edit], param: "address"
    resources "/residents", ResidentController, except: [:new, :edit]
    resources "/roads", RoadController, except: [:new, :edit]
  end
end
