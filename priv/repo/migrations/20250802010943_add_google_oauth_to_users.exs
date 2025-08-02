defmodule Trackguests3.Repo.Migrations.AddGoogleOauthToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :google_id, :string
      add :first_name, :string
      add :last_name, :string
      add :picture_url, :string
    end

    create unique_index(:users, [:google_id])
  end
end
