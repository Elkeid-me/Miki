defmodule Miki.Experiments.Participate do
  import Plug.Conn
  import Miki.Experiments
  import Miki.Users
  import Miki.Utils

  def init(options), do: options

  def call(conn, _opts) do
    with exp_id when exp_id != nil <- conn.params["id"],
         [token] <- get_req_header(conn, "token"),
         user_id when user_id != nil <- get_id_by_token(token),
         %{active: active}
         when active <- active?(exp_id) do
      case add_volunteer(user_id, exp_id) do
        {:ok, _} -> conn |> send_message("Participate in successfully.")
        {:error, _} -> conn |> send_message("Failed to participate.")
      end
    else
      _ -> conn |> send_message("Invalid parameters.", 401)
    end
  end
end
