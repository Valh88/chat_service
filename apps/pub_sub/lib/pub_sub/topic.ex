defmodule PubSub.Topic do
  alias Db.{Contacts}
  alias PubSub.Presence

  @table PubSub.DispatcherRegistry
  def register(topic, data) do
    Registry.register(@table, topic, data)
  end

  def lookup(topic) do
    Registry.lookup(@table, topic)
  end

  def unregister_broadcast(topic) do
    fun = fn data ->
      for {pid, id} <- data do
        if topic != id do
          send(pid, {:broadcast, {:status, topic, "offline"}})
        end
      end
    end

    Registry.dispatch(@table, topic, fun)
  end

  def unregister(user_id) do
    Registry.unregister(@table, user_id)
  end

  def status(topic, pid) do
    Registry.values(@table, topic, pid)
  end

  def subscripe_another_user_if_in_contacts(user_id) do
    users_on_sub_to_user = Contacts.contact_users_by_contact_id(user_id)

    for user <- users_on_sub_to_user do
      case Presence.get_online_user(user) do
        {pid, _contact_id_if_current_user_in_contact} ->
          send(pid, {:broadcast, {:status, user_id, "online"}})

        _ ->
          false
      end
    end
  end
end
