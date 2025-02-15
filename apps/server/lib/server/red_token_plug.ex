defmodule Server.RedTokenPlug do
  import Plug.Conn

  def init(default), do: default

  def call(%Plug.Conn{} = conn, _default) do
    # IO.inspect(conn)
    case conn.query_params["token"] do
      nil ->
        conn
        |> assign(:token, nil)

      # |> halt()

      token ->
        conn
        |> assign(:token, token)
    end
  end
end
