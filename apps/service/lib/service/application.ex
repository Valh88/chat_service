defmodule Service.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def application do
    [
      extra_applications: [:logger, :hackney]
    ]
  end

  @impl true
  def start(_type, _args) do
    Server.Session.init()

    children = [
      # Starts a worker by calling: Service.Worker.start_link(arg)
      # {Service.Worker, arg}
      Db.Repo,
      {Bandit, plug: Server.RouterBuilder, scheme: :http, port: 4000},
      PubSub.RegistrySupervisor,
      PubSub.RoomDynamicSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Service.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
