defmodule Miki.Repo.Migrations.CreateUsersExperiments do
  use Ecto.Migration

  def change do
    create table(:users_experiments) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:experiment_id, references(:experiments, on_delete: :delete_all))
    end

    create(unique_index(:users_experiments, [:experiment_id, :user_id]))
  end
end
