defmodule CacheTest do
  use ExUnit.Case, async: false
  require Logger

  alias Smartlang.Cache
  import ExUnit.CaptureLog

  describe "get_or_store" do
    setup do
      on_exit(fn ->
        # clean up cache
        for {key, _val} <- ConCache.ets(Smartlang.Cache.table_name()) |> :ets.tab2list() do
          ConCache.delete(Smartlang.Cache.table_name(), key)
        end
      end)

      :ok
    end

    test "returns error when func call to fetch supported language fails - {:error, error_message}" do
      assert Cache.get_or_store(:supported_languages, fn -> stub_func(:error) end) ==
               {:error, "Error Occured"}
    end

    test "stores supported languages in cache upon a successful func response - {:ok, Languages}" do
      log =
        capture_log(fn ->
          assert Cache.get_or_store(:supported_languages, fn -> stub_func(:ok) end) ==
                   {:ok,
                    [
                      %{"displayName" => "English", "languageCode" => "en"},
                      %{"displayName" => "French", "languageCode" => "fr"}
                    ]}
        end)

      # The first time stub_func is invoked to fetch supported languages
      assert log =~ "[CacheTest.stub_func(:ok)] Fetched Supported Languages"

      log =
        capture_log(fn ->
          assert Cache.get_or_store(:supported_languages, fn -> stub_func(:ok) end) ==
                   {:ok,
                    [
                      %{"displayName" => "English", "languageCode" => "en"},
                      %{"displayName" => "French", "languageCode" => "fr"}
                    ]}
        end)

      # The second time it's fetching from cache
      refute log =~ "[CacheTest.stub_func(:ok)] Fetched Supported Languages"
    end
  end

  def stub_func(:ok) do
    Logger.warning("[CacheTest.stub_func(:ok)] Fetched Supported Languages")

    {:ok,
     [
       %{"displayName" => "English", "languageCode" => "en"},
       %{"displayName" => "French", "languageCode" => "fr"}
     ]}
  end

  def stub_func(:error) do
    {:error, "Error Occured"}
  end
end
