defmodule Miki.Plug.Login do
  import Plug.Conn
  def init(options), do: options

  def call(conn, _opts) do
    if conn.method != "POST" do
      send_resp(conn, 404, "Only accept POST method.")
    end
  end
end
