defmodule Miki.Users.Login do
  import Plug.Conn
  import Miki.Users
  import Miki.Utils

  def init(options), do: options

  def call(conn, _opts) do
    with %{"email" => email, "password" => password} <- conn.body_params do
      user = get_user_by(:email, email)

      if user && user.password == password do
        conn |> put_resp_header("token", user.token) |> send_message("Successfully logged in.")
      else
        conn |> send_message("Invalid email or password.")
      end
    else
      _ -> conn |> send_message("Invalid parameters.")
    end
  end
end
