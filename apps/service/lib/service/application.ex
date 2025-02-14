defmodule Service.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Service.Worker.start_link(arg)
      # {Service.Worker, arg}
      Db.Repo,
      {Bandit, plug: Server.RouterBuilder, scheme: :http, port: 4000}
      # :ets.new(:session, [:named_table, :public, read_concurrency: true]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Service.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
