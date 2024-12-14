defmodule Miki.Utils do
  import Jason
  import Plug.Conn

  def send_json(conn, data, status \\ 200) do
    json = encode!(data)
    conn |> put_resp_content_type("application/json") |> send_resp(status, json)
  end

  def send_message(conn, message, status \\ 200),
    do: conn |> send_json(%{"message" => message}, status)

  def current_time(), do: DateTime.now("Etc/UTC") |> elem(1) |> DateTime.truncate(:second)
end
