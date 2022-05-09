defmodule Platform.Repo.Migrations.CreateIdentity do
  use Ecto.Migration

  def change do
    create table(:identity, primary_key: false) do
      add(:id, :uuid, primary_key: true)

      add(:provider_id, :string, null: false)
      add(:provider, :string, null: false)

      add(:provider_token, :string, null: false)
      add(:provider_login, :string, null: false)

      add(:provider_email, :string, null: false)
      add(:provider_meta, :map, default: "{}", null: false)

      add(:user_id, references(:user, type: :uuid, on_delete: :delete_all), null: false)
      timestamps()
    end

    create index(:identity, [:user_id])
    create index(:identity, [:provider])
    create unique_index(:identity, [:user_id, :provider])
  end
end
