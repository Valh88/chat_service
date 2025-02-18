defmodule PubSub.RegistrySupervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(_opts) do
    children = [
      {Registry, keys: :duplicate, name: PubSub.DispatcherRegistry,  partitions: System.schedulers_online()},
      {Registry, keys: :unique, name: PubSub.UsersPresence, partitions: System.schedulers_online()}
    ]
    opts = [strategy: :one_for_one, name: Service.RegistrySupervisor]
    Supervisor.init(children, opts)
  end
end
