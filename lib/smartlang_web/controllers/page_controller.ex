defmodule SmartlangWeb.PageController do
  use SmartlangWeb, :controller
  require Logger

  def index(conn, _params) do
    file_path = Path.join(:code.priv_dir(:smartlang), "static/fe/dist/index.html")

    case File.read(file_path) do
      {:ok, content} ->
        rendered = String.replace(content, "__CSRF_TOKEN__", Plug.CSRFProtection.get_csrf_token())

        conn
        |> put_resp_content_type("text/html")
        |> send_resp(200, rendered)

      {:error, reason} ->
        Logger.error(
          "[SmartlangWeb.PageController] Unable to render index.html due to: #{inspect(reason)}"
        )

        send_resp(conn, 404, "index.html not found")
    end
  end
end
