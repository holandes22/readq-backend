use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :read_q, ReadQ.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :read_q, ReadQ.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "read_q_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :read_q,
  entry_limit: 10
