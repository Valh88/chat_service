defmodule Server.RouterBuilder do
  use Plug.Builder

  alias Server.Routers.{AuthentificationRegistration}
  plug(Plug.Session, store: :ets, key: "_my_app_session", table: :session)
  plug(Plug.Parsers, parsers: [:json, :urlencoded], json_decoder: Jason)

  plug(:fetch_session)

  plug(AuthentificationRegistration)
end
