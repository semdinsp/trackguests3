defmodule Trackguests3.Repo.Migrations.AddLocalesToShowGuestsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :locales_to_show_guests, {:array, :string}, default: ["en"], null: false
    end
  end
end
