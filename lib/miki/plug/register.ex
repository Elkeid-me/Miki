defmodule Miki.Plug.Register do
  import Plug.Conn
  import Jason
  import Miki.Users

  def init(options), do: options

  def call(conn, _opts) do
    if conn.method != "POST" do
      send_resp(conn, 404, "Only accept POST method.")
    else
      with %{
             "username" => username,
             "nickname" => nickname,
             "email" => email,
             "password" => password
           } <- conn.body_params do
        cond do
          get_user_by_name(username) != [] ->
            json = encode!(%{"message" => "Username already exists."})
            conn |> put_resp_content_type("application/json") |> send_resp(200, json)

          get_user_by_email(email) != [] ->
            json = encode!(%{"message" => "Email already exists."})
            conn |> put_resp_content_type("application/json") |> send_resp(200, json)

          true ->
            add_user(username, nickname, email, password)
            json = encode!(%{"message" => "Successfully registered."})
            conn |> put_resp_content_type("application/json") |> send_resp(200, json)
        end
      else
        _ ->
          json = encode!(%{"message" => "Invalid parameters."})
          conn |> put_resp_content_type("application/json") |> send_resp(200, json)
      end
    end
  end
end
