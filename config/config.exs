# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :open_budget,
  ecto_repos: [OpenBudget.Repo]

# Configures the endpoint
config :open_budget, OpenBudgetWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aN2o/h57OsXeuJTFr6A2XwENBMTJazo2mtGAi84mMwvJc/or8VO4Ig60mW+xlgQb",
  render_errors: [view: OpenBudgetWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: OpenBudget.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :format_encoders,
  "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
