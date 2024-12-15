defmodule Miki.Router do
  use Plug.Router
  import Miki.Utils

  plug(Plug.Logger)

  plug(Corsica,
    origins: "*",
    allow_credentials: true,
    allow_methods: ["OPTIONS", "GET", "POST"],
    allow_headers: :all
  )

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
  get("/users/instruction/:id", to: Miki.Users.Instruction)
  get("/users/instruction", to: Miki.Users.Instruction)

  get "/experiments" do
    {count, exps} = Miki.Experiments.all_active()

    conn
    |> send_json(%{
      "count" => count,
      "results" => exps |> Enum.map(fn exp -> Miki.Experiments.to_map(exp) end)
    })
  end

  post("/experiments/create", to: Miki.Experiments.Create)
  post("/experiments/edit/:id", to: Miki.Experiments.Edit)
  get("/experiments/:id", to: Miki.Experiments.Detail)
  get("/experiments/participate/:id", to: Miki.Experiments.Participate)

  get("/tags", to: Miki.Tags.All)

  match(_, do: conn |> send_resp(404, "Requested API not exists, or the method is wrong."))
end
