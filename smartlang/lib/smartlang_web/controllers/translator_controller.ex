defmodule SmartlangWeb.TranslatorController do
  use SmartlangWeb, :controller

  require Protocol
  require Logger
  alias GoogleApi.Translate.V3.Connection
  alias GoogleApi.Translate.V3.Api.Projects
  alias GoogleApi.Translate.V3.Model

  @project_id System.get_env("PROJECT_ID")
  @location "global"
  Protocol.derive(Jason.Encoder, Model.SupportedLanguages)
  Protocol.derive(Jason.Encoder, Model.SupportedLanguage)
  Protocol.derive(Jason.Encoder, Model.TranslateTextResponse)
  Protocol.derive(Jason.Encoder, Model.Translation)

  def get_supported_languages(conn, _) do
    gconn = google_connection()
    case  Projects.translate_projects_locations_get_supported_languages(
        gconn,
        "projects/#{@project_id}/locations/#{@location}",
        displayLanguageCode: "en"
    ) do
      {:ok, %Model.SupportedLanguages{} = response} ->
        conn
        |> put_status(:ok)
        |> json(%{response: Map.from_struct(response)})
      {:error, _error} ->
        conn
        |> put_status(:bad_request)
        |> json(%{response: "Unable to translate"})
    end
  end

  def translate_text(conn, params) do
    request = %Model.TranslateTextRequest{
      contents: [params["text"]],
      mimeType: "text/plain",
      sourceLanguageCode: params["source"],
      targetLanguageCode: params["target"]
    }
    gconn = google_connection()
    case Projects.translate_projects_translate_text(
        gconn,
        "projects/#{@project_id}/locations/#{@location}",
        body: request
    ) do
      {:ok, %Model.TranslateTextResponse{} = response} ->
        conn
        |> put_status(:ok)
        |> json(%{response: response})

      {:error, _error} ->
        conn
        |> put_status(:bad_request)
        |> json(%{response: "Unable to translate"})
    end
  end

  defp google_connection() do
    goth = Goth.fetch!(Smartlang.Goth)
    Connection.new(goth.token)
  end
end
