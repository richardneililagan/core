defmodule OpenBudget.Guardian.AuthenticationTest do
  use OpenBudgetWeb.ConnCase

  alias OpenBudget.Authentication, as: AuthContext
  alias OpenBudget.Guardian.Authentication

  @user_attrs %{email: "test@example.com", password: "secretpassword"}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@user_attrs)
      |> AuthContext.create_user()
    user
  end

  describe "#sign_in_by_email_and_password successful authentication" do
    test "returns user JWT", %{conn: conn} do
      user = user_fixture()
      credentials = %{"email" => "test@example.com", "password" => "secretpassword"}
      {status, conn} = Authentication.sign_in_by_email_and_password(conn, credentials)
      assert status == :ok
      assert conn.private.guardian_default_claims["sub"] == "User:#{user.id}"
    end
  end

  describe "#sign_in_by_email_and_password email/password mismatch" do
    test "returns error", %{conn: conn} do
      user_fixture()
      credentials = %{"email" => "test@example.com", "password" => "wrongpassword"}
      {status, error_message, _conn} = Authentication.sign_in_by_email_and_password(conn, credentials)
      assert status == :error
      assert error_message == :unauthorized
    end
  end

  describe "#sign_in_by_email_and_password no user found" do
    test "returns error", %{conn: conn} do
      credentials = %{"email" => "test@example.com", "password" => "secretpassword"}
      {status, error_message, _conn} = Authentication.sign_in_by_email_and_password(conn, credentials)
      assert status == :error
      assert error_message == :not_found
    end
  end
end
