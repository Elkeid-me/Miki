defmodule Miki.Experiments.Edit do
  import Plug.Conn
  import Miki.Users
  import Miki.Utils
  import Miki.Experiments

  def init(options), do: options

  def call(conn, _opts) do
    case conn.params["id"] do
      nil ->
        conn |> send_message("Invalid parameters.")

      exp_id ->
        with [token] <- get_req_header(conn, "token"),
             %{id: user_id} <- get_user_fields_by(:token, token, [:id]),
             %{creator_id: creator_id} <- get_experiment_fields_by(:id, exp_id, [:creator_id]),
             true <- user_id == creator_id do
          case conn.body_params
               |> Map.take(["active", "title", "description", "person_wanted", "money_per_person"])
               |> update(exp_id) do
            {:ok, _} -> conn |> send_message("Expriment edited successfully.")
            {:error, _} -> conn |> send_message("Failed to edit expriment.")
          end
        else
          _ -> conn |> send_message("Invalid parameters.")
        end
    end
  end
end
