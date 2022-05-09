defmodule Platform.Accounts.User do
  @moduledoc nil

  use Platform.Schema
  import Ecto.Changeset

  alias Platform.Accounts.Identity

  schema "user" do
    field(:email, :string)
    field(:email_confirmed_at, :utc_datetime)

    field(:first_name, :string)
    field(:last_name, :string)

    field(:role, :string, default: "user")
    field(:avatar_url, :string)

    has_many(:identities, Identity)

    timestamps(type: :utc_datetime)
  end

  @already_exists "ALREADY_EXISTS"
  @required_fields ~w(email)a
  def changeset(changeset, attrs \\ %{}) do
    changeset
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_email()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Platform.Repo)
    |> unique_constraint(:email, name: :user_email_index, message: @already_exists)
  end
end
