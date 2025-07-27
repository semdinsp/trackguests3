defmodule Trackguests3.Repo.Migrations.AddThemeToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :theme, :string, default: "light"
    end
  end
end
