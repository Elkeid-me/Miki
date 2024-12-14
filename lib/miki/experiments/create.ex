defmodule Miki.Experiments.Create do
  import Plug.Conn
  import Miki.Users
  import Miki.Utils
  import Miki.Experiments

  def init(options), do: options

  def call(conn, _opts) do
    with [token] <- get_req_header(conn, "token"),
         user_id when user_id != nil <- get_id_by_token(token),
         %{
           "title" => title,
           "description" => description,
           "person_wanted" => person_wanted,
           "money_per_person" => money_per_person
         } <- conn.body_params do
      case new(title, description, person_wanted, money_per_person, user_id) do
        {:ok, post} -> conn |> send_json(process_experiment(post))
        {:error, _} -> conn |> send_message("Failed to create experiment.")
      end
    else
      _ -> conn |> send_message("Invalid parameters.", 401)
    end
  end
end
