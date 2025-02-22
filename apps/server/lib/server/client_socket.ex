defmodule Server.ClientSocket do
  @behaviour WebSock

  alias Plug.Session
  alias Plug.Session
  alias PubSub.{Topic, Presence}
  alias Server.Session
  alias Db.Users

  def init([options]) do
    user = Session.get_session(options)
    Presence.change_status_online(user.id)
    Topic.subscripe_another_user_if_in_contacts(user.id)
    send(self(), {:event, :contacts})
    {:ok, options}
  end

  def handle_in({"ping", [opcode: :text]}, state) do
    {:reply, :ok, {:text, "pong"}, state}
  end

  def handle_in({"Hello, WebSocket!", [opcode: :text]}, state) do
    {:reply, :ok, {:text, "pong"}, state}
  end

  def handle_info(:push, state) do
    {:reply, :ok, {:text, "test"}, state}
  end

  def handle_info({:broadcast, {:status, user_id, "online"}}, state) do
    current_user = Session.get_session(state)
    pids = Topic.lookup(user_id)

    unless {self(), current_user.id} in pids do
      Topic.register(user_id, current_user.id)
    end

    json = Jason.encode!(%{status: %{user: %{id: user_id, status: "online"}}})
    {:push, {:text, json}, state}
  end

  def handle_info({:broadcast, {:status, user_id, "offline"}}, state) do
    _current_user = Session.get_session(state)
    Registry.unregister(PubSub.DispatcherRegistry, user_id)
    json = Jason.encode!(%{status: %{user: %{id: user_id, status: "offline"}}})
    {:push, {:text, json}, state}
  end

  def handle_info({:event, :contacts}, state) do
    current_user = Session.get_session(state)
    current_user = Users.get_by_id(current_user.id, :preload)

    fun = fn contact ->
      if Presence.is_online?(contact.id) do
        Topic.register(contact.id, current_user.id)
        %{user: contact.id, username: contact.username, status: "online"}
      else
        %{user: contact.id, username: contact.username, status: "offline"}
      end
    end

    contacts = Enum.map(current_user.contacts, fun)
    json = Jason.encode!(%{contacts: contacts})
    {:reply, :ok, {:text, json}, state}
  end

  def terminate(:timeout, state) do
    IO.inspect("termin")
    {:ok, state}
  end

  def terminate(mess, state) do
    IO.inspect(mess)

    case Session.get_session(state) do
      nil ->
        {:stop, :normal, state}

      user ->
        # Session.delete_session(state)
        Presence.change_status_offline(user.id)
        Topic.unregister_broadcast(user.id)
    end

    {:stop, :normal, state}
  end
end
