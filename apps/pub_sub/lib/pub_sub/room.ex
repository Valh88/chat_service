defmodule PubSub.Room do
  @enforce_keys [:name]
  defstruct [
    :name,
    messages: []
  ]

  @type t :: %__MODULE__{
          name: binary(),
          messages: list()
          # messages [%{from:binary}]
        }

  @table PubSub.RoomBroadcast
  @max_lengh 50

  def register(room, data) do
    Registry.register(@table, room, data)
  end

  def unregister(room) do
    Registry.unregister(@table, room)
  end

  def broadcast(room, message) do
    fun = fn data ->
      for {pid, _id} <- data do
        send(pid, {:broadcast, {:room, room, message}})
      end
    end

    Registry.dispatch(@table, room, fun)
  end

  def check_max_length_of_messages(messages) do
    if length(messages) > @max_lengh do
      Enum.take(messages, @max_lengh)
    else
      messages
    end
  end
end
