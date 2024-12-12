defmodule Miki.Users.Register do
  import Miki.Users
  import Miki.Utils.Send

  def init(options), do: options

  def call(conn, _opts) do
    with %{
           "username" => username,
           "nickname" => nickname,
           "email" => email,
           "password" => password
         } <- conn.body_params do
      cond do
        username_exists?(username) ->
          conn |> send_message("Username already exists.")

        email_exists?(email) ->
          conn |> send_message("Email already exists.")

        true ->
          add_user(username, nickname, email, password)
          conn |> send_message("Successfully registered.")
      end
    else
      _ -> conn |> send_message("Invalid parameters.")
    end
  end
end
