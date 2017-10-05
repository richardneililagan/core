defmodule OpenBudgetWeb.AccountControllerTest do
  use OpenBudgetWeb.ConnCase

  alias OpenBudget.Budgets
  alias OpenBudget.Budgets.Account

  @create_attrs %{type: "account", attributes: %{description: "This is an account", name: "Sample Account", category: "Cash"}}
  @update_attrs %{type: "account", attributes: %{description: "This is an updated account", name: "Updated Sample Account", category: "Cash"}}
  @invalid_attrs %{type: "account", attributes: %{description: nil, name: nil, category: nil}}

  def fixture(:account) do
    {:ok, account} = Budgets.create_account(%{description: "This is an account", name: "Sample Account", category: "Cash"})
    account
  end

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all accounts", %{conn: conn} do
      conn = get conn, account_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      conn = post conn, account_path(conn, :create), data: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get conn, account_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "type" => "account",
        "id" => id,
        "attributes" => %{
          "description" => "This is an account",
          "name" => "Sample Account",
          "category" => "Cash"
        }
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, account_path(conn, :create), data: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update account" do
    setup [:create_account]

    test "renders account when data is valid", %{conn: conn, account: %Account{id: id} = account} do
      conn = put conn, account_path(conn, :update, account), data: @update_attrs
      assert json_response(conn, 200)["data"] == %{
        "id" => "#{id}",
        "type" => "account",
        "attributes" => %{
          "description" => "This is an updated account",
          "name" => "Updated Sample Account",
          "category" => "Cash"
        }
      }
    end

    test "renders errors when data is invalid", %{conn: conn, account: account} do
      conn = put conn, account_path(conn, :update, account), data: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete account" do
    setup [:create_account]

    test "deletes chosen account", %{conn: conn, account: account} do
      conn = delete conn, account_path(conn, :delete, account)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, account_path(conn, :show, account)
      end
    end
  end

  defp create_account(_) do
    account = fixture(:account)
    {:ok, account: account}
  end
end
