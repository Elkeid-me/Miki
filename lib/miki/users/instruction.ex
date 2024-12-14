defmodule Miki.Users.Instruction do
  import Plug.Conn
  import Miki.Users
  import Miki.Utils

  def init(options), do: options

  defp send_instru(conn, id, %{username: username, email: email, nickname: nickname}),
    do:
      conn
      |> send_json(%{"username" => username, "email" => email, "nickname" => nickname, "id" => id})

  defp send_instru(conn, _id, nil), do: conn |> send_json(%{})

  def call(conn, _opts) do
    case conn.params["id"] do
      nil ->
        with [token] <- get_req_header(conn, "token"),
             id when id != nil <- get_id_by_token(token) do
          user = instruction(id)
          send_instru(conn, id, user)
        else
          _ -> conn |> send_json(%{})
        end

      id ->
        user = instruction(id)
        send_instru(conn, id, user)
    end
  end
end
