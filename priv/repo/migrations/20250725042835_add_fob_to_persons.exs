defmodule Trackguests3.Repo.Migrations.AddFobToPersons do
  use Ecto.Migration

  def change do
    alter table(:persons) do
      add :fob, :string
    end
  end
end
