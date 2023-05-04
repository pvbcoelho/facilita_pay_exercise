import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :facilita_pay_exercise, FacilitaPayExercise.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "facilita_pay_exercise_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :facilita_pay_exercise, FacilitaPayExerciseWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "c523QoK4DUL6mqZn9EckhdiGd5+xygHuvGXY/NI/70+3OruOVgIt+AVwu45O2uXV",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
