defmodule SmartlangWeb.TranslatorControllerTest do
  use SmartlangWeb.ConnCase
  import Mock

  require Logger
  alias GoogleApi.Translate.V3.Model

  describe "Translator Controller Test" do
    test "should give the languages supported by google translate", %{conn: conn} do
      :timer.sleep(2000)

      with_mocks([
        {GoogleApi.Translate.V3.Api.Projects, [],
         translate_projects_locations_get_supported_languages: fn _google_conn, _url, _opts ->
           {:ok,
            %Model.SupportedLanguages{
              languages: [
                %Model.SupportedLanguage{displayName: "English", languageCode: "en"},
                %Model.SupportedLanguage{displayName: "French", languageCode: "fr"}
              ]
            }}
         end},
        {Goth, [], fetch!: fn _ -> %{token: "token#123"} end},
        {ConCache, [], fetch_or_store: fn _, _, func -> func.() end}
      ]) do
        response =
          get(conn, "/translator/supported_languages")
          |> then(&Jason.decode!(&1.resp_body)["response"])

        assert response["languages"] == [
                 %{
                   "displayName" => "English",
                   "languageCode" => "en",
                   "supportSource" => nil,
                   "supportTarget" => nil
                 },
                 %{
                   "displayName" => "French",
                   "languageCode" => "fr",
                   "supportSource" => nil,
                   "supportTarget" => nil
                 }
               ]
      end
    end

    test "should translate the text to target language", %{conn: conn} do
      with_mocks([
        {GoogleApi.Translate.V3.Api.Projects, [],
         translate_projects_translate_text: fn _google_conn, _url, _opts ->
           {:ok,
            %Model.TranslateTextResponse{
              translations: [%Model.Translation{translatedText: "Bonjour comment allez-vous"}]
            }}
         end},
        {Goth, [], fetch!: fn _ -> %{token: "token#123"} end}
      ]) do
        conn =
          post(conn, "/translator/translate", %{
            "source" => "en",
            "target" => "fr",
            "text" => "Hello, How are you"
          })

        [translation | _tl] =
          Jason.decode!(conn.resp_body) |> then(& &1["response"]["translations"])

        assert translation["translatedText"] == "Bonjour comment allez-vous"
      end
    end
  end
end
