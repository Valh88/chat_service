defmodule PubSub.Topic do
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
end
