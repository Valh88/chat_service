defmodule RoomServerTest do
  use ExUnit.Case

  alias PubSub.{Room,RoomServer}
  setup_all do
    {:ok, pid1} = RoomServer.start_link("1")
    {:ok, %{pid: pid1}}
  end

  test "send_new_message", _ctx do
    # _pid1 = spawn(fn ->
    #   IO.puts("Subscriber")
    #   Room.register("1", "user_3")
    #   receive do
    #     {:room, "1", %{from: from, message: mess}} ->
    #       IO.inspect("new mess")
    #       assert from != "user_1"

    #     _ ->
    #       IO.puts("error")
    #   end
    # end)
    message = %{from: "user_1", message: "message", room: "1"}
    :ok = RoomServer.send_new_message("1", message)
  end

end
