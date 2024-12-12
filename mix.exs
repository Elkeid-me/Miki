defmodule Miki.MixProject do
  use Mix.Project

  def project do
    [
      app: :miki,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Miki.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:ecto_sql, "~> 3.0"},
      {:myxql, "~> 0.7"},
      # {:jason, "~> 1.0"}
    ]
  end
end
