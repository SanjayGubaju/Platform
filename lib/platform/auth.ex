defmodule Platform.Auth do
  @moduledoc nil

  alias Platform.Repo
  alias Platform.Accounts
  alias Platform.Accounts.{User}

  def register_user(attrs) do
    if user = Accounts.user_by_provider(attrs) do
      update_token(attrs)
    else
      create_identity_and_user(attrs)
    end
  end

  defp update_token(attrs) do
    case Accounts.update_identity(attrs) do
      {:ok, %{user_id: user_id}} ->
        user = Accounts.user_by_id(user_id)
        {:ok, user}

      _ ->
        {:error, nil}
    end
  end

  defp create_identity_and_user(attrs) do
    case Accounts.create_identity_and_user(attrs) do
      {:ok, %{user: %User{}} = info} ->
        info.user
        |> send_welcome_email()

        {:ok, info.user}

      _ ->
        {:error, :invalid_argument}
    end
  end

  defp send_welcome_email(%User{} = _) do
    {:ok, nil}
  end
end
