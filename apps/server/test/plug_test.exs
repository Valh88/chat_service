defmodule PlugTest do
  use ExUnit.Case
  use Plug.Test

  test "greets the world" do
    assert Server.hello() == :world
  end

  setup_all %{} do
    %{}
  end

  test "/registration" do
    conn =
      conn(:post, "/registration", %{
        "account" => %{"username" => "username", "password" => "password"}
      })

    conn = Server.RouterBuilder.call(conn, Server.RouterBuilder.init([]))
    assert conn.status == 422
  end

  test "/login" do
    conn =
      conn(:post, "/login", %{"account" => %{"username" => "username", "password" => "password"}})

    conn = Server.RouterBuilder.call(conn, Server.RouterBuilder.init([]))
    assert conn.status == 200
  end

  test "delete user" do
  end
end
