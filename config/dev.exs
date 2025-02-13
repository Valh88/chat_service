use Mix.Config

# Настройки базы данных
config :db, Db.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "database_repo",
  hostname: "localhost",
  pool_size: 10
