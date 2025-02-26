defmodule Server.Cors do
  use Plug.Router

  plug(CORSPlug,
    origin: ["http://example.com", "https://another-domain.com"],
    methods: ["GET", "POST"],
    headers: ["Access-Control-Allow-Origin"]
  )

  plug(:match)
  plug(:dispatch)

  get "/hello" do
    send_resp(conn, 200, "Hello, world!")
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
