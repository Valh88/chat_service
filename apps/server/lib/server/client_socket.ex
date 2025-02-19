defmodule Server.ClientSocket do
  @behaviour WebSock

  alias Plug.Session
  alias PubSub.{Topic, Presence}
  alias Server.Session

  def init([options]) do
    user = Session.get_session(options)
    Presence.change_status_online(user.id)
    Topic.subscripe_another_user_if_in_contacts(user.id)
    Topic.subscribe_to_contacts(user.id)
    send(self(), :push)
    {:ok, options}
  end

  def handle_in({"ping", [opcode: :text]}, state) do
    IO.inspect(state)
    {:reply, :ok, {:text, "pong"}, state}
  end

  def handle_in({"Hello, WebSocket!", [opcode: :text]}, state) do
    # {:reply, :ok, {:text, "pong"}, state}
    {:reply, :ok, {:text, "pong"}, state}
  end

  def terminate(:timeout, state) do
    IO.inspect("termin")
    {:ok, state}
  end

  def handle_info(:push, state) do
    {:reply, :ok, {:text, "test"}, state}
  end

  def terminate(_mess, state) do
    user = Session.get_session(state)
    Session.delete_session(state)
    Presence.change_status_offline(user.id)
    Topic.unregister(user.id)
    {:stop, :normal, state}
  end
end
