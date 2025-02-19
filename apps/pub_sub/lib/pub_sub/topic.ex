defmodule PubSub.Topic do
  alias Db.{Contacts, Users}
  alias PubSub.Presence

  @table PubSub.DispatcherRegistry
  def register(topic, data) do
    Registry.register(@table, topic, data)
  end

  def lookup(topic) do
    Registry.lookup(@table, topic)
  end

  def unregister(topic) do
    Registry.unregister(@table, topic)
  end

  def status(topic, pid) do
    Registry.values(@table, topic, pid)
  end

  def subscripe_another_user_if_in_contacts(user_id) do
    users_on_sub_to_user = Contacts.contact_users_by_contact_id(user_id)
    for user <- users_on_sub_to_user do
      if Presence.is_online?(user) do
        register(user_id, user)
      else
        # IO.inspect(contact)
      end
    end
  end

  def subscribe_to_contacts(user_id) do
    user = Users.get_by_id(user_id, :preload)
    for contact <- user.contacts  do
      if Presence.is_online?(contact.id) do
        register(contact.id, user_id)
      else
        # IO.inspect(contact)
      end
    end
  end
end
