defmodule Miki.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  forward("/users/register", to: Miki.Plug.Register)

  forward("/users/login", to: Miki.Plug.Login)

  match _ do
    conn |> send_resp(404, "404")
  end
end
