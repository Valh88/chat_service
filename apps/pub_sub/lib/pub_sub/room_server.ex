defmodule PubSub.RoomServer do
  use GenServer

  alias PubSub.Room

  @table PubSub.RoomBroadcast

  def start_link(room) do
    # rewrite  - delete via
    GenServer.start_link(__MODULE__, room, name: via(room))
  end

  def init(room) do
    state = %Room{name: room}
    # TODO Maybe save state
    {:ok, state}
  end

  def handle_cast({:new_message, message}, state) do
    IO.inspect(message)
    new_message = %{from: message[:from], message: message[:message]}
    messages =
      [new_message | state.messages]
      |> Room.check_max_length_of_messages()

    send(self(), {:broadcast, state.name, new_message})
    new_state  = %{state | messages: messages}
    {:noreply, new_state}
  end

  def handle_info({:broadcast, room, message}, state) do
    Room.broadcast(room, message)
    {:noreply, state}
  end

  def handle_info(msg, state) do
    IO.inspect(msg)
    {:noreply, state}
  end

  def send_new_message(name, message) do
    GenServer.cast(via(name), {:new_message, message})
  end

  def via(key) do
    {:via, Registry, {@table, key}}
  end
end
