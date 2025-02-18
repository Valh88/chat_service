defmodule Server.ClientSocket do
  @behaviour WebSock

  alias PubSub.Topic
  alias Server.Session

  def init([options]) do
    IO.inspect(options)
    user = Session.get_session(options)
    Topic.register(5, user.id)
    IO.inspect(Topic.lookup(5))
    send(self(), :push)
    {:ok, options}
  end

  def handle_in({"ping", [opcode: :text]}, state) do
    IO.inspect(state)
    {:reply, :ok, {:text, "pong"}, state}
  end

  def handle_in({"Hello, WebSocket!", [opcode: :text]}, state) do
    IO.inspect(state)
    # {:reply, :ok, {:text, "pong"}, state}
    {:reply, :ok, {:text, "pong"}, state}
  end

  # def terminate(:timeout, state) do
  #   IO.inspect("termin")
  #   {:ok, state}
  # end

  def handle_info(:push, state) do
    {:reply, :ok, {:text, "test"}, state}
  end

  def terminate(_mess, state) do
    {:stop, :normal, state}
  end
end
