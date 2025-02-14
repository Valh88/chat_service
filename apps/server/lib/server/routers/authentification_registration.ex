defmodule Server.Routers.AuthentificationRegistration do
  use Plug.Router

  alias Db.Users
  alias Server.Token

  plug(:match)
  plug(:dispatch)

  get "/me" do
    send_resp(conn, 200, "Users List")
  end

  post "/registration" do
    case conn.params do
      %{"account" => %{"username" => username, "password" => password}} ->
        case Users.create(%{"username" => username, "password" => password}) do
          {:ok, _user} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(201, Jason.encode!(%{status: "success"}))

          {:error, changeset} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(
              422,
              Jason.encode!(%{status: "error", errors: Users.changeset_errors(changeset)})
            )
        end

      _ ->
        send_resp(conn, 422, Jason.encode!(%{status: "error", error: "not correct data"}))
    end
  end

  post "/login" do
    case conn.params do
      %{"account" => %{"username" => username, "password" => password}} ->
        with user when user != nil <- Users.get_by_username(username),
             true <- Users.check_username_password?(password, user.password_hash) do
          token = Token.generate_token(%{username: user.username})

          conn
          |> put_resp_content_type("application/json")
          |> send_resp(200, Jason.encode!(%{status: "success", token: token}))
        else
          nil ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(404, Jason.encode!(%{status: "error", error: "user not found"}))

          false ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(404, Jason.encode!(%{status: "error", error: "wrong password"}))

          _ ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(500, Jason.encode!(%{status: "error", error: "server error"}))
        end

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(500, Jason.encode!(%{status: "error", error: "server error"}))
    end
  end

  match _ do
    Server.Routers.NotFound.call(conn, [])
  end
end
