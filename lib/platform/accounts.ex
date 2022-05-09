defmodule Platform.Accounts do
  @moduledoc nil

  import Ecto.Query
  import Ecto.Changeset

  alias Platform.Repo
  alias Platform.Accounts.{Identity, User}

  def create_identity_and_user(attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:user, fn _, %{} -> create_user(attrs) end)
    |> Ecto.Multi.run(:identity, fn _, %{user: user} -> create_identity(user.id, attrs) end)
    |> Repo.transaction()
  end

  def create_identity(user_id, attrs) do
    all_attrs = Map.merge(attrs, %{user_id: user_id})

    %Identity{}
    |> Identity.changeset(all_attrs)
    |> Repo.insert()
  end

  def update_identity(%{email: email} = attrs) do
    get_identity_by_email(email)
    |> Identity.update_token_changeset(attrs)
    |> Repo.update()
  end

  def get_identity_by_email(email) do
    Identity
    |> where([i], i.provider_email == ^email)
    |> Repo.one()
  end

  def user_by_provider(%{provider: provider, email: email}) do
    User
    |> join(:right, [u], _ in assoc(u, :identities))
    |> where([_, i], i.provider == ^to_string(provider))
    |> where([u, _], u.email == ^String.downcase(email))
    |> Repo.one()
  end

  def user_by_id(user_id) do
    User
    |> where([u], u.id == ^user_id)
    |> Repo.one()
  end

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
