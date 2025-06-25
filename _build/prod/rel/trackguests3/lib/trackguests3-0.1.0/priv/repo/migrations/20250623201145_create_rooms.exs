defmodule Trackguests3.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :floor, :integer
      add :needs_fob, :boolean, default: false, null: false
      add :memo, :string
      add :accepts_guests, :boolean, default: false, null: false
      add :residence_id, references(:residences, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:rooms, [:residence_id])
  end
end
