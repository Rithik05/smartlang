defmodule SmartlangWeb.Plugs.AuthorizeUser do
  import Plug.Conn
  require Logger

  alias Smartlang.Auth.Guardian

  def init(default), do: default

  def call(%Plug.Conn{} = conn, _default) do
    with jwt_token when is_bitstring(jwt_token) <-
           get_session(conn, "guardian_default_token", :token_missing),
         {:ok, claims} <- Guardian.decode_and_verify(jwt_token) do
      assign(conn, :user, claims["user"])
    else
      error ->
        Logger.error("[Plugs.AuthorizeUser] error #{inspect(error)}")

        conn
        |> clear_session()
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{response: "Unauthorized"})
        |> halt()
    end
  end
end
