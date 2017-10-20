defmodule OpenBudgetWeb.BudgetControllerTest do
  use OpenBudgetWeb.ConnCase

  alias OpenBudget.Budgets
  alias OpenBudget.Budgets.Budget
  alias OpenBudget.Authentication
  alias OpenBudgetWeb.Authentication, as: WebAuth

  @create_attrs %{name: "Sample Budget", description: "This is a sample budget"}
  @update_attrs %{name: "Updated Sample Budget", description: "This is an updated sample budget"}
  @invalid_attrs %{name: nil, description: nil}

  def fixture(:budget) do
    {:ok, budget} = Budgets.create_budget(@create_attrs)
    budget
  end

  def fixture(:user) do
    {:ok, user} = Authentication.create_user(%{email: "test@example.com", password: "password"})
    user
  end

  setup %{conn: conn} do
    user = fixture(:user)

    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")
      |> WebAuth.sign_in(user)

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all budgets", %{conn: conn} do
      conn = get conn, budget_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create budget" do
    test "renders budget when data is valid", %{conn: conn} do
      params = Poison.encode!(%{data: %{attributes: @create_attrs}})
      conn = post conn, budget_path(conn, :create), params
      assert json_response(conn, 201)["data"]["attributes"] == %{
        "name" => "Sample Budget",
        "description" => "This is a sample budget"
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      params = %{data: %{attributes: @invalid_attrs}}
      conn = post conn, budget_path(conn, :create), params
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update budget" do
    setup [:create_budget]

    test "renders budget when data is valid", %{conn: conn, budget: %Budget{id: id} = budget} do
      params = Poison.encode!(%{data: %{attributes: @update_attrs}})
      conn = put conn, budget_path(conn, :update, budget), params
      assert json_response(conn, 200)["data"] == %{
        "type" => "budget",
        "id" => "#{id}",
        "attributes" => %{
          "name" => "Updated Sample Budget",
          "description" => "This is an updated sample budget"
        }
      }
    end

    test "renders errors when data is invalid", %{conn: conn, budget: budget} do
      params = %{data: %{attributes: @invalid_attrs}}
      conn = put conn, budget_path(conn, :update, budget), params
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete budget" do
    setup [:create_budget]

    test "deletes chosen budget", %{conn: conn, budget: budget} do
      conn = delete conn, budget_path(conn, :delete, budget)
      assert response(conn, 204)
    end
  end

  defp create_budget(_) do
    budget = fixture(:budget)
    {:ok, budget: budget}
  end
end
