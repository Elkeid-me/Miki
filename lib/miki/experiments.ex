defmodule Miki.Experiments do
  use Ecto.Schema
  import Ecto.Query
  import Miki.Utils

  schema "experiments" do
    field(:title, :string)
    field(:description, :string)
    field(:active, :boolean)
    field(:person_wanted, :integer)
    field(:person_already, :integer)
    field(:money_per_person, :decimal)
    field(:money_paid, :decimal)
    field(:money_left, :decimal)
    field(:time_created, :utc_datetime)
    field(:time_modified, :utc_datetime)
    field(:creator_id, :integer)

    many_to_many(:users, Miki.Users,
      join_through: "users_experiments",
      join_keys: [experiment_id: :id, user_id: :id]
    )
  end

  def process_experiment(exp) do
    %{
      "title" => exp.title,
      "description" => exp.description,
      "active" => exp.active,
      "person_wanted" => exp.person_wanted,
      "person_already" => exp.person_already,
      "money_per_person" => exp.money_per_person,
      "money_paid" => exp.money_paid,
      "money_left" => exp.money_left,
      "time_created" => exp.time_created,
      "time_modified" => exp.time_modified,
      "creator_id" => exp.creator_id,
      "id" => exp.id
    }
  end

  def get_experiment_fields_by(by, value, fields),
    do:
      Miki.Experiments |> where(^[{by, value}]) |> select(^fields) |> Miki.Repo.all() |> unique()

  def all_active() do
    query = Miki.Experiments |> where(active: true)

    {query |> Miki.Repo.aggregate(:count),
     query |> order_by(desc: :time_modified) |> Miki.Repo.all()}
  end

  def new_experiment(title, description, person_wanted, money_per_person, creator_id) do
    time_created = current_time()

    %Miki.Experiments{
      title: title,
      description: description,
      active: true,
      person_wanted: person_wanted,
      person_already: 0,
      money_per_person: money_per_person,
      money_paid: 0,
      money_left: 0,
      time_created: time_created,
      time_modified: time_created,
      creator_id: creator_id
    }
    |> Miki.Repo.insert()
  end

  def update(new_info, id),
    do:
      Miki.Experiments
      |> Miki.Repo.get(id)
      |> Ecto.Changeset.cast(new_info, [
        :active,
        :title,
        :description,
        :person_wanted,
        :money_per_person
      ])
      |> Miki.Repo.update()

  def add_volunteer(user_id, exp_id) do
    user = Miki.Users |> Miki.Repo.get(user_id) |> Miki.Repo.preload(:experiments)
    experiment = Miki.Experiments |> Miki.Repo.get(exp_id)

    if experiment.person_wanted > experiment.person_already do
      case user
           |> Ecto.Changeset.change()
           |> Ecto.Changeset.put_assoc(:experiments, [experiment | user.experiments])
           |> Miki.Repo.update() do
        {:ok, _} ->
          experiment
          |> Ecto.Changeset.cast(%{person_already: experiment.person_already + 1}, [
            :person_already
          ])
          |> Miki.Repo.update()
        error -> error
      end
    else
      {:error, 0}
    end
  end
end
