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
    IO.inspect(state)
    {:reply, :ok, {:text, "pong"}, state}
  end

  def handle_in({"Hello, WebSocket!", [opcode: :text]}, state) do
    {:reply, :ok, {:text, "pong"}, state}
  end

  # def terminate(:timeout, state) do
  #   IO.inspect("termin")
  #   {:ok, state}
  # end

  def handle_info(:push, state) do
    {:reply, :ok, {:text, "test"}, state}
  end

  def handle_info({:broadcast, {:status, user_id, status}}, state) do
    json = Jason.encode!(%{status: %{user:  %{id: user_id,  status: status}}})
    {:push, {:text, json}, state}
  end

  def handle_info({:event, :contacts}, state) do
    user = Session.get_session(state)
    user = Users.get_by_id(user.id, :preload)
    fun = fn contact ->
      if Presence.is_online?(contact.id) do
        Topic.register(contact.id, user.id)
        %{user: contact.id, username: contact.username, status: "online"}
      else
        %{user: contact.id, username: contact.username, status: "offline"}
      end
    end
    contacts = Enum.map(user.contacts, fun)
    json = Jason.encode!(%{contacts: contacts})
    {:reply, :ok, {:text, json}, state}
  end

  def terminate(_mess, state) do
    user = Session.get_session(state)
    # Session.delete_session(state)
    Presence.change_status_offline(user.id)
    Topic.unregister(user.id)
    {:stop, :normal, state}
  end
end
