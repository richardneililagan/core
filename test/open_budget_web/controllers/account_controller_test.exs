defmodule OpenBudgetWeb.AccountControllerTest do
  use OpenBudgetWeb.ConnCase

  alias OpenBudget.Authentication
  alias OpenBudget.Budgets
  alias OpenBudget.Budgets.Account
  alias OpenBudget.Guardian.Authentication, as: GuardianAuth

  @create_attrs %{name: "Sample Account", description: "This is an account", category: "Cash"}
  @update_attrs %{name: "Updated Sample Account", description: "This is an updated account", category: "Cash"}
  @invalid_attrs %{name: nil, description: nil, category: nil}

  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(@create_attrs)
      |> Budgets.create_account()
    account
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{email: "test@example.com", password: "password"})
      |> Authentication.create_user()
    user
  end

  setup %{conn: conn} do
    user = user_fixture()

    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")
      |> GuardianAuth.sign_in(user)

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all accounts", %{conn: conn} do
      conn = get conn, account_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show" do
    test "renders budget", %{conn: conn} do
      account = account_fixture()
      conn = get conn, account_path(conn, :show, account.id)

      assert json_response(conn, 200)["data"] == %{
        "type" => "account",
        "id" => "#{account.id}",
        "attributes" => %{
          "name" => "Sample Account",
          "description" => "This is an account",
          "category" => "Cash"
        }
      }
    end
  end

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      params = Poison.encode!(%{data: %{attributes: @create_attrs}})
      conn = post conn, account_path(conn, :create), params
      response = json_response(conn, 201)["data"]

      assert response["attributes"] == %{
        "name" => "Sample Account",
        "description" => "This is an account",
        "category" => "Cash"
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      params = %{data: %{attributes: @invalid_attrs}}
      conn = post conn, account_path(conn, :create), params
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update account" do
    setup [:create_account]

    test "renders account when data is valid", %{conn: conn, account: %Account{id: id} = account} do
      params = Poison.encode!(%{data: %{attributes: @update_attrs}})
      conn = put conn, account_path(conn, :update, account), params
      assert json_response(conn, 200)["data"] == %{
        "id" => "#{id}",
        "type" => "account",
        "attributes" => %{
          "name" => "Updated Sample Account",
          "description" => "This is an updated account",
          "category" => "Cash"
        }
      }
    end

    test "renders errors when data is invalid", %{conn: conn, account: account} do
      params = %{data: %{attributes: @invalid_attrs}}
      conn = put conn, account_path(conn, :update, account), params
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete account" do
    setup [:create_account]

    test "deletes chosen account", %{conn: conn, account: account} do
      conn = delete conn, account_path(conn, :delete, account)
      assert response(conn, 204)
    end
  end

  defp create_account(_) do
    account = account_fixture()
    {:ok, account: account}
  end
end
