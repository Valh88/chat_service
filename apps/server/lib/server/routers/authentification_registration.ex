defmodule Server.Routers.AuthentificationRegistration do
  use Plug.Router
  alias Db.Users
  alias Server.Token
  alias Server.Session
  plug(:match)
  plug(:dispatch)

  get "/me" do
    token = conn.assigns[:token]

    with true <- Token.check_token?(token),
         user when user != nil <- Session.get_session(token) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{status: "success", user: %{id: user.id, username: user.username}}))
    else
      nil ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, Jason.encode!(%{status: "error", error: "invalid token"}))

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(500, Jason.encode!(%{status: "error", error: "server error"}))
    end
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
             true <- Users.check_username_password?(password, user.password_hash),
             token <- Token.generate_token(%{username: user.username}),
             :ok <- Session.put_session(token, user) do
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

  delete("/me") do
    token = conn.assigns[:token]
    with true <- Token.check_token?(token),
      user when user != nil <- Session.get_session(token) do
      Session.delete_session(token)
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{status: "success"}))
    else
    nil ->
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(401, Jason.encode!(%{status: "error", error: "invalid token"}))

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
