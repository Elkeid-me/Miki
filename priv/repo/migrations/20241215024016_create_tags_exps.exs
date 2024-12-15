defmodule Miki.Repo.Migrations.CreateTagsExps do
  use Ecto.Migration

  def change do
    create table(:tags_exps) do
      add(:tag_id, references(:tags, on_delete: :delete_all))
      add(:experiment_id, references(:experiments, on_delete: :delete_all))
    end

    create(unique_index(:tags_exps, [:tag_id, :experiment_id]))
  end
end
