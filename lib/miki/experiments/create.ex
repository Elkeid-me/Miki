defmodule Miki.Experiments.Create do
  import Plug.Conn
  import Miki.Users
  import Miki.Utils
  import Miki.Experiments

  def init(options), do: options

  def call(conn, _opts) do
    with [token] <- get_req_header(conn, "token"),
         %{id: id} <- get_user_fields_by(:token, token, [:id]),
         %{
           "title" => title,
           "description" => description,
           "person_wanted" => person_wanted,
           "money_per_person" => money_per_person
         } <- conn.body_params do
      case new_experiment(title, description, person_wanted, money_per_person, id) do
        {:ok, post} -> conn |> send_json(process_experiment(post))
        {:error, _} -> conn |> send_message("Failed to create experiment.")
      end
    else
      _ -> conn |> send_message("Invalid parameters.", 401)
    end
  end
end
