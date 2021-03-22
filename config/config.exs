# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :toolbox,
  ecto_repos: [Toolbox.Repo]

# Configures the endpoint
config :toolbox, ToolboxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OjnZRk5cxgRYmF9tGD+JYoABs67syFl2t3w94kMfbZivCOrkAWaUQkIB7mapw10Y",
  render_errors: [view: ToolboxWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Toolbox.PubSub,
  live_view: [signing_salt: "BsdcrK5e"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :toolbox,
  debox_id: System.get_env("DEVBOX_ID", nil)

config :toolbox, :basic_auth,
  username: System.get_env("AUTH_NAME"),
  password: System.get_env("AUTH_PASSWORD")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
