defmodule Server.Routers.WebSocket do
  use Plug.Router
  alias Server.{Token, Session}
  plug(:match)
  plug(:dispatch)

  get "/" do
    token = conn.assigns[:token]

    with true <- Token.check_token?(token),
         user when user != nil <- Session.get_session(token) do
      conn
      |> WebSockAdapter.upgrade(Server.ClientSocket, [token], timeout: 60_000)
      |> halt()
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
