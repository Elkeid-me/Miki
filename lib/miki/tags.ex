defmodule Miki.Tags do
  use Ecto.Schema
  alias(Miki.{Experiments, TagsExps})

  schema "tags" do
    field(:name, :string)

    many_to_many(:experiments, Experiments,
      join_through: TagsExps,
      join_keys: [tag_id: :id, experiment_id: :id]
    )
  end
end

defmodule Miki.Tags.All do
  import Ecto.Query
  alias(Miki.{Repo, Tags, Utils})
  def init(options), do: options

  def call(conn, _opts) do
    count = Tags |> Repo.aggregate(:count)
    data = Tags |> select([:name]) |> Repo.all() |> Enum.map(fn tag -> Map.take(tag, [:name]) end)
    conn |> Utils.send_json(%{"count" => count, "result" => data})
  end
end

defmodule Miki.Tags.Query do
  import Ecto.Query
  alias(Miki.{Repo, Tags, Utils})
  def init(options), do: options

  def call(conn, _opts) do
    count = Tags |> Repo.aggregate(:count)
    data = Tags |> select([:name]) |> Repo.all() |> Enum.map(fn tag -> Map.take(tag, [:name]) end)
    conn |> Utils.send_json(%{"count" => count, "result" => data})
  end
end
