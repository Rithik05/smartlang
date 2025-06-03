defmodule Smartlang.Repo do
  use Ecto.Repo,
    otp_app: :smartlang,
    adapter: Ecto.Adapters.Postgres
end
