defmodule SmartlangWeb.SummaryControllerTest do
  use SmartlangWeb.ConnCase
  require Logger

  alias Smartlang.AiClientMock
  import Hammox

  describe "summarizer" do
    test "should summarize the pdf file contents", %{conn: conn} do
      upload = %Plug.Upload{
        content_type: "application/pdf",
        filename: "test.pdf",
        path: "test/support/fixtures/test.pdf"
      }

      AiClientMock
      |> stub(:summarize_file, fn _file_path, _config ->
        {
          :ok,
          %{
            "message" => %{
              "content" => [%{"text" => "This is a summarized mock response"}],
              "role" => "assistant"
            }
          }
        }
      end)

      [translation | _] =
        post(conn, "/summarizer/summarize", %{"file" => upload})
        |> then(&Jason.decode!(&1.resp_body)["response"])

      assert translation["text"] == "This is a summarized mock response"
    end
  end
end
