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
    get "/residents/look/:flr", ResidentController, :look
    post "/residents/act", ResidentController, :act
    get "/roads/look/:flr", RoadController, :look
    
    resources "/bldgs", BldgController, except: [:new, :edit], param: "address"
<<<<<<< HEAD
    resources "/residents", ResidentController, except: [:new, :edit, :index]
=======
    resources "/residents", ResidentController, except: [:new, :edit]
    resources "/roads", RoadController, except: [:new, :edit]
>>>>>>> master
  end
end
