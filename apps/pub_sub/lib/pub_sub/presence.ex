defmodule PubSub.Presence do
  @table PubSub.UsersPresence

  def change_status_online(user_id) do
      Registry.register(@table, user_id, user_id)
  end

  def change_status_offline(user_id) do
    Registry.unregister(@table, user_id)
  end

  def is_online?(user_id) do
    case Registry.lookup(@table, user_id) do
      [{_pid, _user_id}] -> true
      [] -> false
    end
  end
end
