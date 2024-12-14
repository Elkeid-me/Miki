defmodule Miki.Experiments.Edit do
  import Plug.Conn
  import Miki.Users
  import Miki.Utils
  import Miki.Experiments

  def init(options), do: options

  def call(conn, _opts) do
    with exp_id when exp_id != nil <- conn.params["id"],
         [token] <- get_req_header(conn, "token"),
         %{id: user_id} <- get_id_by_token(token),
         %{creator_id: creator_id} when user_id == creator_id <- creator_id(exp_id) do
      case conn.body_params
           |> Map.take(["active", "title", "description", "person_wanted", "money_per_person"])
           |> update(exp_id) do
        {:ok, _} -> conn |> send_message("Expriment edited successfully.")
        {:error, _} -> conn |> send_message("Failed to edit expriment.")
      end
    else
      _ -> conn |> send_message("Invalid parameters.", 401)
    end
  end
end
