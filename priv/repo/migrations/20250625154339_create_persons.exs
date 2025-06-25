defmodule Trackguests3.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string, null: false)
      add(:email, :string)
      add(:phone, :string)
      add(:company, :string)
      add(:purpose_of_visit, :string)
      add(:check_in_time, :utc_datetime)
      add(:check_out_time, :utc_datetime)
      add(:visitor_type, :string, default: "visitor")
      add(:status, :string, default: "checked_out")
      add(:memo, :text)
      add(:room_id, references(:rooms, on_delete: :nilify_all, type: :binary_id))

      timestamps(type: :utc_datetime)
    end

    create(index(:persons, [:room_id]))
    create(index(:persons, [:status]))
    create(index(:persons, [:check_in_time]))
    create(index(:persons, [:email]))
  end
end
