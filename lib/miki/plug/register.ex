defmodule Miki.Plug.Register do
  import Miki.Users
  import Miki.Utils.Send

  def init(options), do: options

  def call(conn, _opts) do
    if conn.method != "POST" do
      conn |> send_message("Only POST method is accepted.", 404)
    else
      with %{
             "username" => username,
             "nickname" => nickname,
             "email" => email,
             "password" => password
           } <- conn.body_params do
        cond do
          get_user_by_name(username) ->
            conn |> send_message("Username already exists.")

          get_user_by_email(email) ->
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
end
