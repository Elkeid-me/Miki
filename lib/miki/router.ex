defmodule Miki.Router do
  use Plug.Router

  plug(Plug.Logger, log: :debug)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  forward("/users/register", to: Miki.Users.Register)

  forward("/users/login", to: Miki.Users.Login)

  match _ do
    conn |> send_resp(404, "404")
  end
end
