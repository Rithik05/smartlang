defmodule Smartlang.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:id, :first_name, :last_name, :email]}
  @required_fields [:first_name, :email]
  @optional_fields [:last_name]
  @cast_fields @required_fields ++ @optional_fields

  @type t :: %__MODULE__{}

  schema "users" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end
end
