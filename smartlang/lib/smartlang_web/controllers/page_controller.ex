defmodule SmartlangWeb.PageController do
  use SmartlangWeb, :controller
  require Logger

  def index(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    file_path = Path.join(:code.priv_dir(:smartlang), "static/fe/dist/index.html")

    case File.read(file_path) do
      {:ok, content} ->
        IO.inspect(content, label: "content")
        rendered = String.replace(content, "__CSRF_TOKEN__", Plug.CSRFProtection.get_csrf_token())
        conn
        |> put_resp_content_type("text/html")
        |> send_resp(200, rendered)
      {:error, reason} ->
        Logger.error("[SmartlangWeb.PageController] Unable to render index.html due to: #{inspect(reason)}")
        send_resp(conn, 404, "index.html not found")
    end
    # conn
    # |> put_resp_content_type("text/html")
    # |> send_file(200, file_path)
  end
end
