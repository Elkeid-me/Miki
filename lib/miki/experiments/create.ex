defmodule Miki.Experiments.Create do
  import Plug.Conn
  alias(Miki.{Experiments, Utils, Users})

  def init(options), do: options

  def call(conn, _opts) do
    with [token] <- get_req_header(conn, "token"),
         user_id when user_id != nil <- Users.get_id_by_token(token),
         %{
           "title" => title,
           "description" => description,
           "person_wanted" => person_wanted,
           "money_per_person" => money_per_person
         } <- conn.body_params do
      case Experiments.new(title, description, person_wanted, money_per_person, user_id) do
        {:ok, post} -> conn |> Utils.send_json(Miki.Experiments.to_map(post))
        {:error, _} -> conn |> Utils.send_message("Failed to create experiment.", 401)
      end
    else
      _ -> conn |> Utils.send_message("Invalid parameters.", 401)
    end
  end
end
