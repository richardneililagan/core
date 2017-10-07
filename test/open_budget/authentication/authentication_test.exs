defmodule OpenBudget.AuthenticationTest do
  use OpenBudget.DataCase

  alias OpenBudget.Authentication

  describe "users" do
    alias OpenBudget.Authentication.User

    @valid_attrs %{email: "test@example.com", password: "secretpassword"}
    @update_attrs %{email: "updated@example.com", password: "updatedsecretpassword"}
    @invalid_attrs %{email: nil, password: nil}
    @nonunique_attrs %{email: "test@example.com", password: "secretpassword"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Authentication.create_user()

      %{user | password: nil}
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Authentication.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Authentication.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Authentication.create_user(@valid_attrs)
      assert user.email == "test@example.com"
      assert user.password_hash != "secretpassword"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authentication.create_user(@invalid_attrs)
    end

    test "create_user/1 with non-unique email returns error changeset" do
      user_fixture()
      assert {:error, %Ecto.Changeset{}} = Authentication.create_user(@nonunique_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Authentication.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "updated@example.com"
      assert user.password_hash != "updatedsecretpassword"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Authentication.update_user(user, @invalid_attrs)
      assert user == Authentication.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Authentication.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Authentication.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Authentication.change_user(user)
    end
  end
end
