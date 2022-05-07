defmodule PlatformWeb.AuthController do
  use PlatformWeb, :controller
  plug Ueberauth, providers: [:github], base_path: "/auth"

  alias Ueberauth.Strategy.Helpers

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

  def callback(%{assigns: %{ueberauth_auth: _}} = conn, _) do
    conn
    |> put_flash(:success, "Successfully authenticated")
    |> redirect(to: "/")
  end
end
