defmodule Miki.Experiments.Create do
  import Miki.Utils
  import Miki.Experiments

  def init(options), do: options

  def call(conn, _opts) do
    with %{
           "title" => title,
           "description" => description,
           "person_wanted" => person_wanted,
           "money_per_person" => money_per_person
         } <- conn.body_params do
      data =
        new_experiment(title, description, person_wanted, money_per_person, 0) # TODO: User ID
        |> elem(1)
        |> process_experiment()

      conn |> send_json(data)
    else
      _ ->
        nil
    end
  end
end
