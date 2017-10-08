defmodule OpenBudget.Authentication.GuardianTest do
  use OpenBudget.DataCase

  alias OpenBudget.Authentication
  alias OpenBudget.Authentication.Guardian

  @user_attrs %{email: "test@example.com", password: "secretpassword"}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@user_attrs)
      |> Authentication.create_user()
    user
  end

  describe "#subject_for_token for %User{}" do
    test "returns User:<id>" do
      user = user_fixture()
      assert Guardian.subject_for_token(user, nil) == {:ok, "User:#{user.id}"}
    end
  end

  describe "#subject_for_token for unknown resource" do
    test "returns error" do
      assert Guardian.subject_for_token(%{some: "thing"}, nil) == {:error, :unknown_resource}
    end
  end

  describe "#resource_from_claims for User:<valid_id>" do
    test "returns {:ok, %User{}}" do
      user = user_fixture()
      user = %{user | password: nil}
      assert Guardian.resource_from_claims(%{"sub" => "User:" <> to_string(user.id)}) == {:ok, user}
    end
  end

  describe "#resource_from_claims for User:<invalid_id>" do
    test "returns {:error, :invalid_id}" do
      assert Guardian.resource_from_claims(%{"sub" => "User:a1b2c3"}) == {:error, :invalid_id}
      assert Guardian.resource_from_claims(%{"sub" => "User:abc123"}) == {:error, :invalid_id}
      assert Guardian.resource_from_claims(%{"sub" => "User:"}) == {:error, :invalid_id}
    end
  end

  describe "#resource_from_claims for User:<non_existing>" do
    test "returns {:error, :no_result}" do
      assert Guardian.resource_from_claims(%{"sub" => "User:99999"}) == {:error, :no_result}
    end
  end

  describe "#resource_from_claims for other strings" do
    test "returns {:error, :invalid_claims}" do
      assert Guardian.resource_from_claims(%{"sub" => "UnknownObject:123"}) == {:error, :invalid_claims}
    end
  end
end