defmodule WebsockTest do
  use ExUnit.Case
  use Plug.Test

  defmodule WebSockClient do
    use WebSockex
    @base_url "ws://127.0.0.1:4001/websocket"

    def start_link(id) do
      url = @base_url <> "?token=" <> id
      {:ok, pid} = WebSockex.start_link(url, __MODULE__, id)
      IO.inspect(pid)
      {:ok, pid}
    end

    def send_frame(client_pid, message) do
      WebSockex.send_frame(client_pid, {:text, message})
    end

    def handle_frame({:text, msg}, state) do
      send(self(), {:text, msg})
      {:ok, state}
    end

    def handle_frame(_frame, state) do
      {:ok, state}
    end
  end

  @users [
    %{"account" => %{"username" => "username1", "password" => "password1"}},
    %{"account" => %{"username" => "username2", "password" => "password2"}},
    %{"account" => %{"username" => "username3", "password" => "password3"}},
    %{"account" => %{"username" => "username4", "password" => "password4"}},
    %{"account" => %{"username" => "username5", "password" => "password5"}},
    %{"account" => %{"username" => "username6", "password" => "password6"}},
    %{"account" => %{"username" => "username7", "password" => "password7"}},
    %{"account" => %{"username" => "username8", "password" => "password8"}},
    %{"account" => %{"username" => "username9", "password" => "password9"}},
    %{"account" => %{"username" => "username10", "password" => "password10"}},
  ]

  setup do
    {:ok, pid} = Bandit.start_link(plug: Server.RouterBuilder, scheme: :http, port: 4001)

    on_exit(fn ->
      IO.puts("Stopping Bandit server...")
      Process.exit(pid, :normal)
    end)

    %{server: pid}
  end

  setup_all  do
    register_login_add_session = fn user ->
      conn =
        conn(:post, "/api/registration", user)

      conn = Server.RouterBuilder.call(conn, Server.RouterBuilder.init([]))
      assert conn.status == 201

      conn =
        conn(:post, "/api/login", user)

      conn = Server.RouterBuilder.call(conn, Server.RouterBuilder.init([]))
      assert conn.status == 200
      Jason.decode!(conn.resp_body)["token"]
    end
    {:ok, %{users: Enum.map(@users, register_login_add_session)}}
  end

  setup_all %{users: users} do
    on_exit(fn ->
      Enum.each(@users, fn user ->
        user = Db.Users.get_by_username(user["account"]["username"])
        Db.Users.delete(user)
      end)
    end)
  end

  test "websockex", %{users: tokens_users} do
    run_client = fn token_client ->
      WebSockClient.start_link(token_client)
    end
    users_pid =
      Enum.map(tokens_users, run_client)
    assert 4 == 4
  end
end
