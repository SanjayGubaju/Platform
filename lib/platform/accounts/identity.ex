defmodule Platform.Accounts.Identity do
  @moduledoc nil

  use Platform.Schema
  import Ecto.Changeset

  alias __MODULE__, as: Identity
  alias Platform.Accounts.User

  schema "identity" do
    field(:provider_id, :string)
    field(:provider, :string)

    field(:provider_token, :string)
    field(:provider_login, :string)

    field(:provider_email, :string)
    field(:provider_meta, :map)

    belongs_to(:user, User)
    timestamps(type: :utc_datetime)
  end

  @additional_fields ~w(provider_login)a
  @required_fields ~w(user_id provider_token provider_email provider provider_id)a
  def changeset(changeset, attrs \\ %{}) do
    changeset
    |> cast(attrs, @required_fields ++ @additional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:provider_meta, max: 10_000)
  end

  def update_token_changeset(%Identity{} = identity, attrs \\ %{}) do
    identity
    |> cast(attrs, [:provider_token])
    |> validate_required([:provider_token])
  end
end
