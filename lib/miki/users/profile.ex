defmodule Miki.Users.Profile do
  import Plug.Conn
  import Miki.Users
  import Miki.Utils

  def init(options), do: options

  def call(conn, _opts) do
    case conn.params["id"] do
      nil ->
        with [token] <- get_req_header(conn, "token"),
             %{username: username, email: email, nickname: nickname, id: id} <-
               get_user_fields_by(:token, token, [:username, :email, :nickname, :id]) do
          conn
          |> send_json(%{
            "username" => username,
            "email" => email,
            "nickname" => nickname,
            "id" => id
          })
        else
          _ -> conn |> send_message("Invalid parameters.")
        end

      id ->
        with %{username: username, email: email, nickname: nickname, id: id} <-
               get_user_fields_by(:id, id, [:username, :email, :nickname, :id]) do
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
