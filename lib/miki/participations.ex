defmodule Miki.Participations do
  use Ecto.Schema
  import Ecto.Query
  alias(Miki.{Experiments, Participations, Repo, Users})

  schema "participations" do
    belongs_to(:user, Users, foreign_key: :user_id)
    belongs_to(:experiment, Experiments, foreign_key: :experiment_id)
    field(:status, :string, default: "to-qualify-user")
  end

  def already_participted?(user_id, exp_id),
    do: Participations |> where(user_id: ^user_id, experiment_id: ^exp_id) |> Repo.exists?()

  def participte(user_id, exp_id) do
    if Users.id_exists?(user_id) && Experiments.id_exists?(exp_id) &&
         Experiments.creator_id(exp_id) != user_id &&
         !already_participted?(user_id, exp_id) do
      %Participations{user_id: user_id, experiment_id: exp_id} |> Repo.insert()
    else
      {:error, ""}
    end
  end

  def change_status(user_id, exp_id, status) do
    if already_participted?(user_id, exp_id) do
      current_status =
        Participations
        |> where(user_id: ^user_id, experiment_id: ^exp_id)
        |> select([:status])
        |> Repo.one()
        |> Map.get(:status)

      case {current_status, status} do
        {"to-qualify-user", "to-check-result"} ->
          %Experiments{person_wanted: person_wanted, person_already: person_already} =
            Experiments
            |> where(id: ^exp_id)
            |> select([:person_wanted, :person_already])
            |> Repo.one()

          if person_already < person_wanted do
            Experiments
            |> where(id: ^exp_id)
            |> Repo.one()
            |> Ecto.Changeset.cast(%{person_already: person_already + 1}, [:person_already])
            |> Repo.update()

            Participations
            |> where(user_id: ^user_id, experiment_id: ^exp_id)
            |> Repo.one()
            |> Ecto.Changeset.cast(%{status: status}, [:status])
            |> Repo.update()
          else
            {:error, ""}
          end

        {"to-check-result", "finished"} ->
          Participations
          |> where(user_id: ^user_id, experiment_id: ^exp_id)
          |> Repo.one()
          |> Ecto.Changeset.cast(%{status: status}, [:status])
          |> Repo.update()

        _ ->
          {:error, ""}
      end
    else
      {:error, ""}
    end
  end
end

defmodule Miki.Participations.Sence do
end
