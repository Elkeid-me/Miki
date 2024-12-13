defmodule Miki.Experiments.Participate do
  import Plug.Conn
  import Miki.Experiments
  import Miki.Users
  import Miki.Utils

  def init(options), do: options

  def call(conn, _opts) do
    with exp_id when exp_id != nil <- conn.params["id"],
         [token] <- get_req_header(conn, "token"),
         %{id: user_id} <- get_user_fields_by(:token, token, [:id]),
         %{active: active}
         when active <-
           get_experiment_fields_by(:id, exp_id, [:active]) do
      case add_volunteer(user_id, exp_id) do
        {:ok, _} -> conn |> send_message("Participate in successfully.")
        {:error, _} -> conn |> send_message("Failed to participate.")
      end
    else
      _ -> conn |> send_message("Invalid parameters.", 401)
    end
  end
end
