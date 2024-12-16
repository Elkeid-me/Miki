defmodule Miki.Users.Login do
  alias(Miki.{Users, Utils})

  def init(options), do: options

  def call(conn, _opts) do
    with %{"email" => email, "password" => password} <- conn.body_params do
      with %Miki.Users{id: id, password: user_password, token: token}
           when user_password == password <- Users.get_id_password_token_by_email(email) do
        conn
        |> Utils.send_json(%{"message" => "Successfully logged in.", "token" => token, "id" => id})
      else
        _ -> conn |> Utils.send_message("Invalid email or password.", 401)
      end
    else
      _ -> conn |> Utils.send_message("Invalid parameters.", 401)
    end
  end
end
