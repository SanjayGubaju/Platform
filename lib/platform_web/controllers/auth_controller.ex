defmodule PlatformWeb.AuthController do
  use PlatformWeb, :controller
  plug(Ueberauth, providers: [:github], base_path: "/auth")

  alias Ueberauth.Strategy.Helpers
  alias Platform.Auth

  def request(conn, _) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _) do
    conn
    |> put_flash(:info, "Logged in successfully")
    |> clear_session()
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _}} = conn, _) do
    conn
    |> put_flash(:error, "Failed to authenticate")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: data}} = conn, params) do
    Map.merge(generate_identity(data, params), generate_user(data, params))
    |> Auth.register_user()
    |> case do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome #{user.first_name} #{user.last_name}")
        |> redirect(to: "/")

      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to login.")
        |> redirect(to: "/")
    end
  end

  defp generate_identity(
         %{
           credentials: %{token: _} = credentials,
           info: %{email: _} = info
         } = data,
         params
       ) do
    %{
      provider_token: Map.get(credentials, :token),
      provider_id: to_string(Map.get(data, :uid)),
      provider_login: Map.get(info, :nickname),
      provider_email: Map.get(info, :email),
      provider: params["provider"]
    }
  end

  defp generate_user(
         %{
           credentials: %{token: _} = credentials,
           info: %{email: _} = info
         } = data,
         params
       ) do
    [first_name | last_name] = String.split(Map.get(info, :name))

    %{
      email: Map.get(info, :email),
      avatar_url: Map.get(info, :image),
      first_name: first_name,
      last_name: last_name
    }
  end

  def sign_out(conn, _) do
    if socket_id = get_session(conn, :live_socket_id) do
      PhoenixWeb.Endpoint.broadcast(socket_id, "disconnect", %{})
    end

    conn
    |> configure_session(renew: true)
    |> clear_session()
    |> redirect(to: Routes.sign_in_path(conn, :index))
  end
end
