defmodule Miki.Users.Edit do
  import Plug.Conn
  alias(Miki.{Users, Utils})

  def init(options), do: options

  def call(conn, _opts) do
    with [token] <- get_req_header(conn, "token"),
         %{id: id} <- Users.get_id_by_token(token) do
      case conn.body_params
           |> Map.take(["password", "username", "email", "nickname"])
           |> Users.update(id) do
        {:ok, _} -> conn |> Utils.send_message("Profile edited successfully.")
        {:error, _} -> conn |> Utils.send_message("Failed to edit Profile.")
      end
    else
      _ -> conn |> Utils.send_message("Invalid parameters.", 401)
    end
  end
end
