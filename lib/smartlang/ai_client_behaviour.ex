defmodule Smartlang.AiClientBehaviour do
  @callback summarize_file(String.t(), keyword()) :: {:ok, map()} | {:error, any()}
end
