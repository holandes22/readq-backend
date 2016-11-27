# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :read_q,
  ecto_repos: [ReadQ.Repo],
  entry_limit: String.to_integer(System.get_env("ENTRY_LIMIT") || "2000")

# Configures the endpoint
config :read_q, ReadQ.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8BLRb0Rzgcqt22jpVC+1y1KJswHTXSFNcaHNPrnKx1BIyHlHWF7XyBfqQCQDNW3o",
  render_errors: [view: ReadQ.ErrorView, accepts: ~w(json json-api)],
  pubsub: [name: ReadQ.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configure strategy
config :read_q, GitHub,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
  redirect_uri: System.get_env("GITHUB_REDIRECT_URI")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :phoenix, :format_encoders,
  "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

config :oauth2, debug: true

config :policy_wonk, PolicyWonk,
  policies: ReadQ.Policies
