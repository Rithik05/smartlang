defmodule Smartlang.Service.User do
  alias Smartlang.Schema.User
  import Ecto.Query
  alias Smartlang.Repo
  require Logger

  @spec retrieve(%{optional(atom()) => any()}) :: User.t() | nil
  def retrieve(attrs) when is_map(attrs) do
    query =
      Enum.reduce(attrs, User, fn {key, value}, query_acc ->
        from u in query_acc, where: field(u, ^key) == ^value
      end)

    Repo.one(query)
  end

  @spec create_user(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @spec find_or_create(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def find_or_create(%{email: email} = payload) do
    case retrieve(%{email: email}) do
      %User{email: ^email} = user ->
        Logger.info("[Service.Users] Found user")
        {:ok, user}

      nil ->
        create_user(payload)
    end
  end
end
