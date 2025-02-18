defmodule Server.RouterBuilder do
  use Plug.Builder

  alias Server.Routers.{Forward}
  plug(Plug.Parsers, parsers: [:json, :urlencoded], json_decoder: Jason)

  plug(Server.RedTokenPlug)
  # plug(AuthentificationRegistration)
  plug(Forward)
  # plug(WebSocket)
end
