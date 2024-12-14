defmodule Miki.Users.Login do
  import Miki.Users
  import Miki.Utils

  def init(options), do: options

  def call(conn, _opts) do
    with %{"email" => email, "password" => password} <- conn.body_params do
      with %Miki.Users{id: id, password: user_password, token: token}
           when user_password == password <- get_id_password_token_by_email(email) do
        conn |> send_json(%{"message" => "Successfully logged in.", "token" => token, "id" => id})
      else
        _ -> conn |> send_message("Invalid email or password.")
      end
    else
      _ -> conn |> send_message("Invalid parameters.", 401)
    end
  end
end
