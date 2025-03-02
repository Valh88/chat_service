defmodule PubSub.RoomDynamicSupervisor do
  use DynamicSupervisor

  alias PubSub.RoomServer

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_new_room(room) do
    spec = {RoomServer, room}
    case DynamicSupervisor.start_child(__MODULE__, spec) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, _pid}} -> :already_started
    end
  end
end
