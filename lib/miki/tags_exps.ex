defmodule Miki.TagsExps do
  use Ecto.Schema
  alias(Miki.{Experiments, Tags})

  schema "tags_exps" do
    belongs_to(:tag, Tags, foreign_key: :tag_id)
    belongs_to(:experiment, Experiments, foreign_key: :experiment_id)
  end
end
