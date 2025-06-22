{:ok, _} = Application.ensure_all_started(:smartlang)

Ecto.Adapters.SQL.Sandbox.mode(Smartlang.Repo, :manual)
ExUnit.start()
