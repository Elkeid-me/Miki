defmodule Miki.Users.Profile do
  import Miki.Users
  import Miki.Utils

  def init(options), do: options

  def call(conn, _opts) do
    case conn.params["id"] do
      nil ->
        conn |> send_message("OK?")

      id ->
        with %{username: username, email: email, nickname: nickname, id: id} <- get_user_by_id(id) do
          conn
          |> send_json(%{
            "username" => username,
            "email" => email,
            "nickname" => nickname,
            "id" => id
          })
        else
          _ -> conn |> send_json(%{})
        end
    end
  end
end
