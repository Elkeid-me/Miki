defmodule Miki.Repo.Migrations.CreateExperiments do
  use Ecto.Migration

  def change do
    create table(:experiments) do
      add :experiment_name, :string
      add :experiment_description, :longtext
      add :experiment_active?, :boolean
      add :person_wanted, :integer
      add :person_already, :integer
      add :money_per_person, :decimal
      add :money_paid, :decimal
      add :money_left, :decimal
      add :time_created, :date
      add :time_modified, :date
      add :creator_id, :integer
    end
  end
end
