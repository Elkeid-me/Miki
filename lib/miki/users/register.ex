defmodule Miki.Users.Register do
  import Miki.Users
  import Miki.Utils

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
          case add_user(username, nickname, email, password) do
            {:ok, post} ->
              conn |> send_json(%{"message" => "Successfully registered.", "token" => post.token})

            {:error, _} ->
              conn |> send_message("Failed to register.")
          end
      end
    else
      _ -> conn |> send_message("Invalid parameters.", 401)
    end
  end
end
