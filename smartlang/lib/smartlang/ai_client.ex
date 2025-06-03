defmodule Smartlang.AiClient do
  @moduledoc "AI client via Finch"

  def summarize_file(file_path, url: url, api_key: api_key, data_config: data_config) do
    with {content, 0} <- System.cmd("pdftotext", [file_path, "-"]),
         payload = build_payload(content, data_config),
         {:ok, body} <- Jason.encode(payload),
         {:ok, %Finch.Response{status: 200, body: response_body}} <-
           Finch.build(:post, url, build_headers(api_key), body) |> Finch.request(Smartlang.Finch) do
      {:ok, Jason.decode!(response_body)}
    else
      {:ok, %Finch.Response{status: code, body: body}} ->
        {:error, "Failed with status #{code}: #{inspect(body)}"}

      {:error, %Jason.EncodeError{message: message}} ->
        {:error, "Error occured while encoding payload: #{inspect(message)}"}

      {:error, error} ->
        {:error, "Request failed: #{inspect(error)}"}

      {error_message, _int} ->
        {:error, "Unable to parse pdf file error: #{inspect(error_message)} "}
    end
  end

  defp build_payload(content, messages: :required, temperature: temp, model: model) do
    %{
      messages: build_messages(content),
      temperature: temp,
      model: model
    }
  end

  defp build_payload(content, messages: :required, models: model) do
    %{
      messages: build_messages(content),
      model: model
    }
  end

  defp build_messages(content) do
    [
      %{role: "system", content: "You are a helpful assistant that summarizes file content."},
      %{role: "user", content: "Please summarize the following content:\n\n#{content}"}
    ]
  end

  defp build_headers(api_key) do
    [
      {"Authorization", "Bearer #{api_key}"},
      {"Content-Type", "application/json"}
    ]
  end
end
