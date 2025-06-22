defmodule Service.UserTest do
  use Smartlang.DataCase
  alias Smartlang.Schema.User, as: UserSchema
  alias Smartlang.Service.User

  @user_attrs %{
    first_name: "test",
    last_name: "user",
    email: "testuser@smartlang.com"
  }
  describe "user service" do
    test "retrieve/1" do
      {:ok, %UserSchema{id: uid}} = User.create_user(@user_attrs)

      assert User.retrieve(Map.take(@user_attrs, [:email])).id == uid
    end

    test "create_user/1" do
      params = %{
        first_name: "test",
        last_name: "user",
        email: "testuser@smartlang.com"
      }

      {:ok, %UserSchema{} = user} = User.create_user(@user_attrs)
      assert user.email == params.email
    end

    test "find_or_create/1" do
      assert User.retrieve(Map.take(@user_attrs, [:email])) |> is_nil()
      {:ok, %UserSchema{} = user} = User.find_or_create(@user_attrs)
      assert user.email == @user_attrs.email
    end
  end
end
