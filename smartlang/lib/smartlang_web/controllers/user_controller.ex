defmodule SmartlangWeb.UserController do
  use SmartlangWeb, :controller
  alias Smartlang.Service.User, as: UserService
  alias Smartlang.Schema.User

  def user_info(conn, _params) do
    user = conn.assigns[:user]

    case UserService.retrieve(%{id: user["id"]}) do
      %User{} = user ->
        conn
        |> put_status(:ok)
        |> json(%{response: user})

      nil ->
        conn
        |> put_status(:bad_request)
        |> json(%{response: "User Not Found"})
    end
  end
end
