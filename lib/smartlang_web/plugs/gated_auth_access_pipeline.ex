defmodule SmartlangWeb.Plugs.GatedAuthAccessPipeline do
  use Plug.Builder

  plug Smartlang.Auth.Pipeline

  def call(conn, opts) do
    # call the `Smartlang.Auth.Pipeline` plug only if configured to do so. if config is not set, no
    # authentication is required to access the endpoint

    case System.get_env("REQUIRE_AUTH_ENABLED") == "true" do
      true ->
        conn
        |> super(opts)

      false ->
        conn
    end
  end
end
