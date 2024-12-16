defmodule Miki.Experiments.Edit do
  import Plug.Conn
  alias(Miki.{Experiments, Users, Utils})

  def init(options), do: options

  def call(conn, _opts) do
    with exp_id when exp_id != nil <- conn.params["id"],
         [token] <- get_req_header(conn, "token"),
         %{id: user_id} <- Users.get_id_by_token(token),
         %{creator_id: creator_id} when user_id == creator_id <- Experiments.creator_id(exp_id) do
      case conn.body_params
           |> Map.take(["active", "title", "description", "person_wanted", "money_per_person"])
           |> Experiments.update(exp_id) do
        {:ok, _} -> conn |> Utils.send_message("Expriment edited successfully.")
        {:error, _} -> conn |> Utils.send_message("Failed to edit expriment.", 401)
      end
    else
      _ -> conn |> Utils.send_message("Invalid parameters.", 401)
    end
  end
end
