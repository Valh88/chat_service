defmodule Sip.Server do
  require Logger

  # @port 5060

  # def start do
  #       {:ok, listen_socket} = :gen_tcp.listen(@port, [
  #     :binary,
  #     packet: :line,
  #     active: false,
  #     reuseaddr: true
  #   ])

  #   Logger.info("TCP-сервер  #{@port}")

  #   accept_connections(listen_socket)
  # end

  # defp accept_connections(listen_socket) do
  #   {:ok, client_socket} = :gen_tcp.accept(listen_socket)
  #   Logger.info("new connect")

  #   spawn(fn -> handle_client(client_socket) end)

  #   accept_connections(listen_socket)
  # end

  # defp handle_client(client_socket) do
  #   case :gen_tcp.recv(client_socket, 0) do
  #     {:ok, data} ->
  #       Logger.info("#{inspect(data)}")
  #       :gen_tcp.send(client_socket, "echo: #{data}")
  #       handle_client(client_socket)

  #     {:error, :closed} ->
  #       Logger.info("Disconnect")
  #       :gen_tcp.close(client_socket)
  #   end
  # end

  # @server_host {127, 0, 0, 1}  # Адрес сервера (в виде charlist)
  # @server_port 5060       # Порт сервера

  # def start do
  #   # Подключаемся к серверу
  #   case :gen_tcp.connect(@server_host, @server_port, [:binary, packet: :line]) do
  #     {:ok, socket} ->
  #       IO.puts("Подключено к серверу #{"127.0.0.1"}:#{@server_port}")
  #       {:ok, {localAddress, localPort}} = :inet.sockname(socket)
  #       IO.inspect(localAddress)
  #       IO.inspect( localPort)
  #       send_message(socket)
  #       receive_message(socket)
  #       # :gen_tcp.close(socket)

  #     {:error, reason} ->
  #       IO.puts("Ошибка подключения: #{reason}")
  #   end
  # end

  # defp send_message(socket) do
  #   # Отправляем сообщение на сервер
  #   message = "SIP/2.0 401 Unauthorized\r\nVia: SIP/2.0/tcp
  # 192.168.1.4:5060;branch=z9hG4bK12345;received=192.168.1.4;rport=5061\r\nFrom: Alice
  # <sip:1001@192.168.1.4>;tag=9698861739467600\r\nTo:
  # <sip:1002@192.168.1.4>;tag=as7072ef30\r\nCall-ID: 9698861739467600\r\nCSeq: 1 INVITE\r\nServer:
  # Asterisk PBX 18.10.0~dfsg+~cs6.10.40431411-2\r\nAllow: INVITE, ACK, CANCEL, OPTIONS, BYE,
  # REFER, SUBSCRIBE, NOTIFY, INFO, PUBLISH, MESSAGE\r\nSupported: replaces,
  # timer\r\nWWW-Authenticate: Digest algorithm=MD5, realm=\"asterisk\",
  # nonce=\"48f3bfb0\"\r\nContent-Length: 0\r\n\r\n"
  #   :gen_tcp.send(socket, message)
  #   IO.puts("Отправлено: #{message}")
  # end


  # defp receive_message(socket) do
  #   # Получаем ответ от сервера
  #   case :gen_tcp.recv(socket, 0) do
  #     {:ok, data} ->
  #       IO.puts("Получено: #{data}")

  #     {:error, reason} ->
  #       IO.puts("Ошибка при получении данных: #{reason}")
  #   end
  # end


  @sip_server_host 'localhost'
  @sip_server_port 5060
  @username "1001"
  @password "1234"
  @domain "localhost"

  def start do
    case :gen_tcp.connect(@sip_server_host, @sip_server_port, [:binary, active: false]) do
      {:ok, socket} ->
        {:ok, {localAddress, localPort}} = :inet.sockname(socket)
        IO.inspect(localAddress)
        IO.inspect( localPort)
        IO.puts("Подключено к SIP #{@sip_server_host}:#{@sip_server_port}")
        send_register_request(socket)
        receive_response(socket)
        # :gen_tcp.close(socket)

      {:error, reason} ->
        IO.puts("Ошибка : #{reason}")
    end
  end

  defp send_register_request(socket) do
    # REGISTER
    request = """
    REGISTER sip:#{@domain} SIP/2.0\r
    Via: SIP/2.0/TCP #{@domain}:#{@sip_server_port};branch=z9hG4bK12345\r
    Max-Forwards: 70\r
    From: <sip:#{@username}@#{@domain}>;tag=67890\r
    To: <sip:#{@username}@#{@domain}>\r
    Call-ID: 1234567890@#{@domain}\r
    CSeq: 1 REGISTER\r
    Contact: <sip:#{@username}@#{@domain}:#{@sip_server_port}>\r
    Expires: 3600\r
    Content-Length: 0\r
    \r
    """

    :gen_tcp.send(socket, request)
    IO.puts("Отправлен SIP-запрос REGISTER:\n#{request}")
  end

  defp receive_response(socket) do
    # Получаем ответ от сервера
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        IO.puts("Получен ответ от сервера:\n#{data}")

      {:error, reason} ->
        IO.puts("Ошибка при получении данных: #{reason}")
    end
  end
end
