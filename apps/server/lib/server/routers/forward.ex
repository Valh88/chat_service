defmodule Server.Routers.Forward do
  use Plug.Router
  alias Server.Routers.{AuthentificationRegistration, WebSocket, NotFound}

  plug :match
  plug :dispatch

  forward "/api", to: AuthentificationRegistration
  forward "/websocket", to: WebSocket
  match _, do: NotFound.call(conn, [])
end
