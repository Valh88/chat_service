defmodule Sip.Server do
  require Logger

  @port 5060

  def start do
        {:ok, listen_socket} = :gen_tcp.listen(@port, [
      :binary,
      packet: :line,
      active: false,
      reuseaddr: true
    ])

    Logger.info("TCP-сервер  #{@port}")

    accept_connections(listen_socket)
  end

  defp accept_connections(listen_socket) do
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)
    Logger.info("new connect")

    spawn(fn -> handle_client(client_socket) end)

    accept_connections(listen_socket)
  end

  defp handle_client(client_socket) do
    case :gen_tcp.recv(client_socket, 0) do
      {:ok, data} ->
        Logger.info("#{inspect(data)}")
        :gen_tcp.send(client_socket, "echo: #{data}")
        handle_client(client_socket)

      {:error, :closed} ->
        Logger.info("Disconnect")
        :gen_tcp.close(client_socket)
    end
  end
end
