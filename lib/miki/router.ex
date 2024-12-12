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

  post("/users/register", to: Miki.Users.Register)
  post("/users/login", to: Miki.Users.Login)
  get("/users/profile/:id", to: Miki.Users.Profile)
  get("/users/profile", to: Miki.Users.Profile)
  post("experiments/create", to: Miki.Experiments.Create)

  match _ do
    conn |> send_resp(404, "Requested API not exists, or the method is wrong.")
  end
end
