defmodule Miki.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string)
      add(:nickname, :string)
      add(:email, :string)
      add(:password, :string)
      add(:token, :string)
      add(:register_time, :utc_datetime)
    end

    create(unique_index(:users, [:username]))
    create(unique_index(:users, [:email]))
  end
end
