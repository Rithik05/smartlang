defmodule SmartlangWeb.SummaryController do
  use SmartlangWeb, :controller
  require Logger
  alias Smartlang.AiClient

  def summarize(
        conn,
        %{
          "file" => %Plug.Upload{
            path: path,
            content_type: "application/pdf"
          }
        }
      ) do
    cohere_creds = Application.fetch_env!(:smartlang, :cohere_creds)

    case AiClient.summarize_file(path, cohere_creds) do
      {:ok,
       %{
         "message" => %{
           "content" => contents,
           "role" => "assistant"
         }
       }} ->
        Logger.info("[SummaryController.summarize] pdf summarized successfully")

        conn
        |> put_status(:ok)
        |> json(%{response: contents})

      {:error, reason} ->
        Logger.error(
          "[SummaryController.summarize] Unable to summarize pdf due to the error: #{inspect(reason)}"
        )

        conn
        |> put_status(:bad_request)
        |> json(%{response: "Unable to Summarize Content"})
    end
  end
end
