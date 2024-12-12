defmodule Miki.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy,
       scheme: :http, plug: Miki.Router, options: [port: Application.get_env(:miki, :port)]},
      Miki.Repo
    ]

    opts = [strategy: :one_for_one, name: Miki.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
