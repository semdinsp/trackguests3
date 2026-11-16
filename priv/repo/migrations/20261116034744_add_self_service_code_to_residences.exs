defmodule Trackguests3.Repo.Migrations.AddSelfServiceCodeToResidences do
  use Ecto.Migration

  import Ecto.Query

  def up do
    alter table(:residences) do
      add :self_service_code, :string
    end

    create unique_index(:residences, [:self_service_code])

    flush()

    # Give every existing property a code so its QR codes work straight away.
    from(r in "residences", select: r.id)
    |> repo().all()
    |> Enum.each(fn id ->
      from(r in "residences", where: r.id == ^id)
      |> repo().update_all(set: [self_service_code: generate_code()])
    end)
  end

  def down do
    drop index(:residences, [:self_service_code])

    alter table(:residences) do
      remove :self_service_code
    end
  end

  defp generate_code, do: :crypto.strong_rand_bytes(12) |> Base.url_encode64(padding: false)
end
