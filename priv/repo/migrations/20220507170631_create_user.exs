defmodule Platform.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user, primary_key: false) do
      add(:id, :uuid, primary_key: true)

      add(:first_name, :string)
      add(:last_name, :string)

      add(:email, :string)
      add(:email_confirmed_at, :utc_datetime)

      add(:role, :string, default: "user")
      add(:avatar_url, :string)

      timestamps()
    end

    create(unique_index(:user, [:email]))
  end
end
