# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :summoner_web,
  namespace: SummonerWeb

# Configures the endpoint
config :summoner_web, SummonerWebWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nKTOx7fdEfOEgOZDHvj345lKdw4GHXNJmdo25Mszlk/pP79wUYto3MYM+Yk8bZTj",
  render_errors: [view: SummonerWebWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SummonerWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
