defmodule Miki.Users.Instruction do
  import Plug.Conn
  alias(Miki.{Users, Utils})

  def init(options), do: options

  defp send_instru(conn, id, %{username: username, email: email, nickname: nickname}),
    do:
      conn
      |> Utils.send_json(%{"username" => username, "email" => email, "nickname" => nickname, "id" => id})

  defp send_instru(conn, _id, nil), do: conn |> Utils.send_json(%{})

  def call(conn, _opts) do
    case conn.params["id"] do
      nil ->
        with [token] <- get_req_header(conn, "token"),
             id when id != nil <- Users.get_id_by_token(token) do
          user = Users.instruction(id)
          conn |> send_instru(id, user)
        else
          _ -> conn |> Utils.send_json(%{})
        end

      id ->
        user = Users.instruction(id)
        conn |> send_instru(id, user)
    end
  end
end
