defmodule Miki.Users.Instruction do
  import Plug.Conn
  alias(Miki.{Users, Utils})

  def init(options), do: options

  defp send_instru(conn, nil), do: conn |> Utils.send_json(%{})

  defp send_instru(conn, user) do
    data = user |> Map.take([:username, :email, :nickname, :id])

    conn |> Utils.send_json(data)
  end

  def call(conn, _opts) do
    case conn.params["id"] do
      nil ->
        with [token] <- get_req_header(conn, "token"),
             id when id != nil <- Users.get_id_by_token(token) do
          user = Users.instruction(id)
          conn |> send_instru(user)
        else
          _ -> conn |> Utils.send_json(%{})
        end

      id ->
        user = Users.instruction(id)
        conn |> send_instru(user)
    end
  end
end
