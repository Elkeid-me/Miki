defmodule Miki.Users.Login do
  import Miki.Users
  import Miki.Utils

  def init(options), do: options

  def call(conn, _opts) do
    with %{"email" => email, "password" => password} <- conn.body_params do
      user = get_user_fields_by(:email, email, [:password, :token, :id])

      if user && user.password == password do
        conn
        |> send_json(%{
          "message" => "Successfully logged in.",
          "token" => user.token,
          "id" => user.id
        })
      else
        conn |> send_message("Invalid email or password.")
      end
    else
      _ -> conn |> send_message("Invalid parameters.")
    end
  end
end
