defmodule Server.Routers.NotFound do
  import Plug.Conn

  def init(_opts), do: nil

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(404, "<h1>Page not found</h1>")
  end
end
