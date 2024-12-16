defmodule Miki.Experiments.Participate do
  import Plug.Conn
  alias(Miki.{Experiments, Participations, Users, Utils})

  def init(options), do: options

  def call(conn, _opts) do
    with exp_id when exp_id != nil <- conn.params["id"],
         [token] <- get_req_header(conn, "token"),
         user_id when user_id != nil <- Users.get_id_by_token(token),
         %{active: active}
         when active <- Experiments.active?(exp_id) do
      case Participations.participte(user_id, exp_id) do
        {:ok, _} -> conn |> Utils.send_message("Participate in successfully.")
        {:error, _} -> conn |> Utils.send_message("Failed to participate.", 401)
      end
    else
      _ -> conn |> Utils.send_message("Invalid parameters.", 401)
    end
  end
end
