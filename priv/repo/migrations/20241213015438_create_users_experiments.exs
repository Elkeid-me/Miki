defmodule Miki.Repo.Migrations.CreateUsersExperiments do
  use Ecto.Migration

  def change do
    create table(:participations) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:experiment_id, references(:experiments, on_delete: :delete_all))
      add(:status, :string, default: "to-qualify-user")
    end

    create(unique_index(:participations, [:experiment_id, :user_id]))
  end
end
