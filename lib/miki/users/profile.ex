defmodule Miki.Users.Profile do
  import Plug.Conn
  import Miki.Users
  import Miki.Utils

  def init(options), do: options

  defp send_profile(conn, nil), do: conn |> send_json(%{})

  defp send_profile(conn, user) do
    created = user.experiments_created |> Enum.map(fn exp -> Miki.Experiments.to_map(exp) end)

    participate_in =
      user.experiments_participate_in |> Enum.map(fn exp -> Miki.Experiments.to_map(exp) end)

    data =
      user
      |> Map.take([:username, :email, :nickname, :register_time, :id])
      |> Map.put(:experiments_created, created)
      |> Map.put(:experiments_participate_in, participate_in)

    conn |> send_json(data)
  end

  def(call(conn, _opts)) do
    case conn.params["id"] do
      nil ->
        with [token] <- get_req_header(conn, "token"),
             id when id != nil <- get_id_by_token(token) do
          user = profile(id)
          conn |> send_profile(user)
        else
          _ -> conn |> send_json(%{})
        end

      id ->
        user = profile(id)
        conn |> send_profile(user)
    end
  end
end
