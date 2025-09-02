defmodule Trackguests3.Repo.Migrations.AddTimezoneToResidences do
  use Ecto.Migration

  def change do
    alter table(:residences) do
      add :timezone, :string, default: "America/New_York"
    end
  end
end
