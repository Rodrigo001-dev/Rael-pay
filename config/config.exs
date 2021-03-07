# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :raelPay,
  ecto_repos: [RaelPay.Repo]

# Configures the endpoint
config :raelPay, RaelPayWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CEtYy2lkChADSX/5anzZDLMaQKQrZjocjyPfnBDEdEXpqfkdJK5YlDpV9Du7Ipv1",
  render_errors: [view: RaelPayWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: RaelPay.PubSub,
  live_view: [signing_salt: "eaFi8CoB"]

config :raelPay, RaelPay.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreing_key: [type: :binary_id]

config :raelPay, :basic_auth,
  username: "banana",
  password: "nanica123"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
