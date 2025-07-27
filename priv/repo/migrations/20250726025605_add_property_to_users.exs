defmodule Trackguests3.Repo.Migrations.AddPropertyToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :property_id, references(:residences, type: :binary_id, on_delete: :nilify_all)
    end

    create index(:users, [:property_id])
  end
end
