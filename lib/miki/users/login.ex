defmodule Miki.Users.Login do
  import Miki.Users
  import Miki.Utils

  def init(options), do: options

  def call(conn, _opts) do
    with %{"email" => email, "password" => password} <- conn.body_params do
      user = get_user_by_email(email)

      if user do
        if user.password == password do
          conn |> send_message("Successfully logged in.")
        else
          conn |> send_message("Invalid email or password.")
        end
      end
    else
      _ -> conn |> send_message("Invalid parameters.")
    end
  end
end
