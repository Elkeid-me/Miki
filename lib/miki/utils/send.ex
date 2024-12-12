defmodule Miki.Utils.Send do
  import Jason
  import Plug.Conn

  def send_json(conn, data, status) do
    json = encode!(data)
    conn |> put_resp_content_type("application/json") |> send_resp(status, json)
  end

  def send_message(conn, message, status \\ 200),
    do: conn |> send_json(%{"message" => message}, status)
end
