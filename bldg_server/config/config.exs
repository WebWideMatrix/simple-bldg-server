# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :bldg_server, BldgServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dtSP0Wp19QkEaDEdB0cdMoTnf7dtD0/Sb4ZCV+Z5jkh+0QOVdNVuV1YfCD/Zk5M6",
  render_errors: [view: BldgServerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BldgServer.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "5GI7mf6c"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
