defmodule OpenBudgetWeb.UserControllerTest do
  use OpenBudgetWeb.ConnCase

  alias OpenBudget.Authentication
  alias OpenBudget.Authentication.User

  @create_attrs %{email: "test@example.com", password: "secretpassword"}
  @update_attrs %{email: "updated@example.com", password: "updatedsecretpassword"}
  @invalid_attrs %{email: nil, password: nil}

  def fixture(:user) do
    {:ok, user} = Authentication.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      params = Poison.encode!(%{data: %{attributes: @create_attrs}})
      conn = post conn, user_path(conn, :create), params
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "type" => "user",
        "id" => id,
        "attributes" => %{
          "email" => "test@example.com"
        }
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      params = %{data: %{attributes: @invalid_attrs}}
      conn = post conn, user_path(conn, :create), params
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      params = Poison.encode!(%{data: %{attributes: @update_attrs}})
      conn = put conn, user_path(conn, :update, user), params
      assert json_response(conn, 200)["data"] == %{
        "type" => "user",
        "id" => "#{id}",
        "attributes" => %{
          "email" => "updated@example.com"
        }
      }
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      params = %{data: %{attributes: @invalid_attrs}}
      conn = put conn, user_path(conn, :update, user), params
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
