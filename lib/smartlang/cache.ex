defmodule Smartlang.Cache do
  @doc """
    Tries to retrieve data from cache and if it is not available in cache. Will make a call to google translate api
    to fetch the supported languages.
  """
  def get_or_store(key, func) do
    ConCache.fetch_or_store(table_name(), key, func)
  end

  defp table_name() do
    Application.get_env(:smartlang, :concache_config)
    |> Keyword.fetch!(:name)
  end
end
