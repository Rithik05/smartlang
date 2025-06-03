defmodule SmartlangWeb.AuthController do
  use SmartlangWeb, :controller
  require Logger

  plug Ueberauth, otp_app: :smartlang
  alias Smartlang.Auth.Guardian
  alias Smartlang.UserFromAuth
  alias Smartlang.Schema.User

  def user_info(%Plug.Conn{assigns: %{user: user}} = conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{response: user})
  end

  def user_info(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> json(%{response: "Unauthorized"})
  end

  def sign_out(conn, _params) do
    Logger.info("[AuthController] sign_out user")

    conn
    |> Guardian.Plug.sign_out()
    |> put_status(:ok)
    |> json(%{response: "Successfully signed out"})
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    Logger.info("[AuthController.callback] OAuth success")

    case UserFromAuth.oauth_login(auth) do
      {:ok, %User{} = user} ->
        conn
        |> Guardian.Plug.sign_in(user, %{}, ttl: {2, :days})
        |> redirect(to: "/home")

      {:error, changeset} ->
        Logger.error(changeset.errors)

        conn
        |> put_status(:internal_server_error)
        |> redirect(to: "/login")
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    Logger.info("[AuthController] callback failure")

    conn
    |> put_status(:unauthorized)
    |> redirect(to: "/login")
  end
end
