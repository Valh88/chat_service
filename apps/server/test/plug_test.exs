defmodule PlugTest do
  use ExUnit.Case
  use Plug.Test

  test "greets the world" do
    assert Server.hello() == :world
  end

  setup_all %{} do
    %{}
  end

  # on_exit do

  # end

  test "/registration" do
    conn =
      conn(:post, "/registration", %{
        "account" => %{"username" => "username", "password" => "password"}
      })

    conn = Server.RouterBuilder.call(conn, Server.RouterBuilder.init([]))
    assert conn.status == 201

    conn =
      conn(:post, "/registration", %{
        "account" => %{"username" => "username", "password" => "password"}
      })

    conn = Server.RouterBuilder.call(conn, Server.RouterBuilder.init([]))
    assert conn.status == 422

    user = Db.Users.get_by_username("username")
    assert user.username == "username"
    Db.Users.delete(user)
  end

  test "/login" do
    Db.Users.create(%{password: "password", username: "username"})

    conn =
      conn(:post, "/login", %{"account" => %{"username" => "username", "password" => "password"}})

    conn = Server.RouterBuilder.call(conn, Server.RouterBuilder.init([]))
    assert conn.status == 200

    user = Db.Users.get_by_username("username")
    user.username == "username"
    Db.Users.delete(user)
  end

  test "delete user" do
  end
end
