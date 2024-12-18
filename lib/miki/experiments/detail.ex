defmodule Miki.Experiments.Detail do
  alias(Miki.{Experiments, Utils})

  def init(options), do: options

  defp send_detail(conn, nil), do: conn |> Utils.send_json(%{})

  defp send_detail(conn, exp) do
    users = exp.users |> Enum.map(fn exp -> Miki.Users.to_map(exp) end)
    creator = Miki.Users.to_map(exp.creator)

    data = exp |> Experiments.to_map() |> Map.put(:users, users) |> Map.put(:creator, creator)

    conn |> Utils.send_json(data)
  end

  def call(conn, _opts) do
    with exp_id when exp_id != nil <- conn.params["id"] do
      exp = Experiments.detail(exp_id)
      conn |> send_detail(exp)
    end
  end
end
