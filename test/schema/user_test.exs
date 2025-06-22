defmodule Schema.UserTest do
  alias Smartlang.Schema.User
  use Smartlang.DataCase

  describe "user schema" do
    test "defines fields" do
      assert User.__schema__(:fields) == [
               :id,
               :first_name,
               :last_name,
               :email,
               :inserted_at,
               :updated_at
             ]
    end
  end

  describe "user changeset" do
    test "defines fields" do
      changeset = User.changeset(%User{}, %{})

      assert Map.keys(changeset.types) == [
               :id,
               :inserted_at,
               :first_name,
               :last_name,
               :email,
               :updated_at
             ]
    end

    test "validates required fields" do
      changeset = User.changeset(%User{}, %{})

      assert changeset.required == [:first_name, :email]
    end

    test "validates constraints" do
      changeset = User.changeset(%User{}, %{})

      assert changeset.constraints == [
               %{
                 match: :exact,
                 type: :unique,
                 constraint: "users_email_index",
                 error_type: :unique,
                 field: :email,
                 error_message: "has already been taken"
               }
             ]
    end
  end
end
