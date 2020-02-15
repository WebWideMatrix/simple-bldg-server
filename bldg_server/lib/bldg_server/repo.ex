defmodule BldgServer.Repo do
  use Ecto.Repo,
    otp_app: :bldg_server,
    adapter: Ecto.Adapters.Postgres
end
