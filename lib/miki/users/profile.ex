defmodule Miki.Users.Profile do
  import Plug.Conn
  alias(Miki.{Experiments, Users, Utils})

  def init(options), do: options

  defp send_profile(conn, nil), do: conn |> Utils.send_json(%{})

  defp send_profile(conn, user) do
    created = user.experiments_created |> Enum.map(fn exp -> Experiments.to_map(exp) end)

    participate_in =
      user.experiments_participate_in |> Enum.map(fn exp -> Experiments.to_map(exp) end)

    data =
      user
      |> Map.take([:username, :email, :nickname, :register_time, :id])
      |> Map.put(:experiments_created, created)
      |> Map.put(:experiments_participate_in, participate_in)

    conn |> Utils.send_json(data)
  end

  def(call(conn, _opts)) do
    case conn.params["id"] do
      nil ->
        with [token] <- get_req_header(conn, "token"),
             id when id != nil <- Users.get_id_by_token(token) do
          user = Users.profile(id)
          conn |> send_profile(user)
        else
          _ -> conn |> Utils.send_json(%{})
        end

      id ->
        user = Users.profile(id)
        conn |> send_profile(user)
    end
  end
end
