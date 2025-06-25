defmodule Trackguests3.Repo.Migrations.CreateResidences do
  use Ecto.Migration

  def change do
    create table(:residences, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :address, :string
      add :floor_count, :integer
      add :logo, :binary

      timestamps(type: :utc_datetime)
    end
  end
end
