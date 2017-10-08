defmodule OpenBudgetWeb.TokenControllerTest do
  use OpenBudgetWeb.ConnCase

  alias OpenBudget.Authentication, as: AuthContext

  @valid_attrs %{email: "test@example.com", password: "secretpassword"}
  @invalid_attrs %{email: "test@example.com", password: "wrongpassword"}
  @non_existent_attrs %{email: "nonexistent@example.com", password: "wrongpassword"}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> AuthContext.create_user()
    user
  end

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    user_fixture()
    {:ok, conn: conn}
  end

  describe "create" do
    test "renders access_token when data is valid", %{conn: conn} do
      params = Poison.encode!(%{data: %{attributes: @valid_attrs}})
      conn = post conn, token_path(conn, :create), params
      assert json_response(conn, 201)["access_token"] != nil
    end

    test "renders error when data matches user but wrong combination", %{conn: conn} do
      params = Poison.encode!(%{data: %{attributes: @invalid_attrs}})
      conn = post conn, token_path(conn, :create), params
      response = json_response(conn, 401)["errors"]
      response = hd(response)
      assert response["code"] == 401
      assert response["title"] == "Unauthorized"
    end

    test "renders error when data does not match any user", %{conn: conn} do
      params = Poison.encode!(%{data: %{attributes: @non_existent_attrs}})
      conn = post conn, token_path(conn, :create), params
      response = json_response(conn, 404)["errors"]
      response = hd(response)
      assert response["code"] == 404
      assert response["title"] == "Resource not found"
    end
  end
end
