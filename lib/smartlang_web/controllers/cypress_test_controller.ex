defmodule SmartlangWeb.CypressTestController do
  use SmartlangWeb, :controller

  alias Smartlang.Auth.Guardian
  alias Smartlang.Schema.User
  alias Smartlang.Service.User, as: UserService
  @valid_user_email "valid_user@smartlang.com"

  def login(conn, %{"email" => @valid_user_email}) do
    case create_mock_user(@valid_user_email) do
      {:ok, %User{} = user} ->
        conn
        |> Guardian.Plug.sign_in(user, %{}, ttl: {2, :days})
        |> put_status(:ok)
        |> json(%{response: "Authentication successful"})

      {:error, _changeset} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{response: "Internal Server Error"})
    end
  end

  def login(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> json(%{response: "UnAuthorized"})
  end

  def create_mock_user(email) do
    %{email: email, first_name: "test", last_name: "user"}
    |> UserService.find_or_create()
  end
end
