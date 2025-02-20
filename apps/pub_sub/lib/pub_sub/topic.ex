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

  def unregister(topic) do
    fun = fn data ->
      for {pid, id} <- data do
        if topic != id do
          send(pid, {:broadcast, {:status, topic, "offline"}})
        end
      end
    end
    Registry.dispatch(@table, topic, fun)
    Registry.unregister(@table, topic)
  end

  def status(topic, pid) do
    Registry.values(@table, topic, pid)
  end

  def subscripe_another_user_if_in_contacts(user_id) do
    users_on_sub_to_user = Contacts.contact_users_by_contact_id(user_id)

    fun = fn data ->
      for {pid, id} <- data do
        if user_id != id do
          send(pid, {:broadcast, {:status, user_id, "online"}})
        end
      end
    end
    for user <- users_on_sub_to_user do
      if Presence.is_online?(user) do
        register(user_id, user)
        Registry.dispatch(@table, user_id, fun)
      else
        # IO.inspect("dsadsad")
      end
    end
  end
end
