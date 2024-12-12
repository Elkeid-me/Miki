defmodule Miki.Repo.Migrations.CreateExperiments do
  use Ecto.Migration

  def change do
    create table(:experiments) do
      add(:title, :string)
      add(:description, :longtext)
      add(:active?, :boolean)
      add(:person_wanted, :integer)
      add(:person_already, :integer)
      add(:money_per_person, :decimal)
      add(:money_paid, :decimal)
      add(:money_left, :decimal)
      add(:time_created, :utc_datetime)
      add(:time_modified, :utc_datetime)
      add(:creator_id, :integer)
    end
  end
end
