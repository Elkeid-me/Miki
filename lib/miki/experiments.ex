defmodule Miki.Experiments do
  use Ecto.Schema
  import Ecto.Query
  alias Miki.TagsExps
  alias(Miki.{Experiments, Participations, Repo, Tags, TagsExps, Users, Utils})

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
    belongs_to(:creator, Users, foreign_key: :creator_id)

    many_to_many(:users, Users,
      join_through: Participations,
      join_keys: [experiment_id: :id, user_id: :id]
    )

    many_to_many(:tags, Tags,
      join_through: TagsExps,
      join_keys: [experiment_id: :id, tag_id: :id]
    )
  end

  @doc """
  提取实验的简要信息，转换为 Map。输入应为 %Experiment{}
  """
  def to_map(exp),
    do:
      exp
      |> Map.take([
        :title,
        :description,
        :active,
        :person_wanted,
        :person_already,
        :money_per_person,
        :money_paid,
        :money_left,
        :time_created,
        :time_modified,
        :creator_id,
        :id
      ])

  def detail(id),
    do:
      Experiments
      |> where(id: ^id)
      |> select([
        :title,
        :description,
        :active,
        :person_wanted,
        :person_already,
        :money_per_person,
        :money_paid,
        :money_left,
        :time_created,
        :time_modified,
        :creator_id,
        :id
      ])
      |> Repo.one()
      |> Repo.preload([:users, :creator])

  def active?(id), do: Experiments |> where(id: ^id) |> select([:active]) |> Repo.one()

  def creator_id(id),
    do: Experiments |> where(id: ^id) |> select([:creator_id]) |> Repo.one()

  def all_active() do
    query = Experiments |> where(active: true)

    {query |> Repo.aggregate(:count), query |> order_by(desc: :time_modified) |> Repo.all()}
  end

  def new(title, description, person_wanted, money_per_person, creator_id) do
    time_created = Utils.current_time()

    %Experiments{
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
    |> Repo.insert()
  end

  def id_exists?(id), do: Experiments |> where(id: ^id) |> Repo.exists?()

  def update(attrs, id),
    do:
      Experiments
      |> where(id: ^id)
      |> Repo.one()
      |> Ecto.Changeset.cast(attrs, [
        :active,
        :title,
        :description,
        :person_wanted,
        :money_per_person
      ])
      |> Repo.update()
end
