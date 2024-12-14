defmodule Miki.Users.Register do
  alias(Miki.{Users, Utils})

  def init(options), do: options

  def call(conn, _opts) do
    with %{
           "username" => username,
           "nickname" => nickname,
           "email" => email,
           "password" => password
         } <- conn.body_params do
      cond do
        Users.username_exists?(username) ->
          conn |> Utils.send_message("Username already exists.")

        Users.email_exists?(email) ->
          conn |> Utils.send_message("Email already exists.")

        true ->
          case Users.new(username, nickname, email, password) do
            {:ok, post} ->
              conn
              |> Utils.send_json(%{
                "message" => "Successfully registered.",
                "id" => post.id,
                "token" => post.token
              })

            {:error, _} ->
              conn |> Utils.send_message("Failed to register.")
          end
      end
    else
      _ -> conn |> Utils.send_message("Invalid parameters.", 401)
    end
  end
end
