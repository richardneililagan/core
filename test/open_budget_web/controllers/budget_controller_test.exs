defmodule OpenBudgetWeb.BudgetControllerTest do
  use OpenBudgetWeb.ConnCase

  alias OpenBudget.Repo
  alias OpenBudget.Budgets
  alias OpenBudget.Authentication
  alias OpenBudget.Authentication.User
  alias OpenBudget.Guardian.Authentication, as: GuardianAuth

  @create_attrs %{name: "Sample Budget", description: "This is a sample budget"}
  @update_attrs %{name: "Updated Sample Budget", description: "This is an updated sample budget"}
  @invalid_attrs %{name: nil, description: nil}

  def budget_fixture(attrs \\ %{}) do
    {:ok, budget} =
      attrs
      |> Enum.into(@create_attrs)
      |> Budgets.create_budget()
    budget
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
    test "lists all budgets", %{conn: conn} do
      user = Repo.get_by(User, %{email: "test@example.com"})
      budget = budget_fixture()
      Budgets.associate_user_to_budget(budget, user)
      conn = get conn, budget_path(conn, :index)
      assert length(json_response(conn, 200)["data"]) == 1
    end

    test "list only budgets associated to the user", %{conn: conn} do
      user = Repo.get_by(User, %{email: "test@example.com"})
      budget_fixture()
      budget = budget_fixture(%{name: "Associated Budget", category: "Cash"})
      Budgets.associate_user_to_budget(budget, user)
      conn = get conn, budget_path(conn, :index)

      assert length(json_response(conn, 200)["data"]) == 1
    end
  end

  describe "show" do
    test "render budget associated with the current user", %{conn: conn} do
      user = Repo.get_by(User, %{email: "test@example.com"})
      budget = budget_fixture()
      Budgets.associate_user_to_budget(budget, user)
      conn = get conn, budget_path(conn, :show, budget.id)

      assert json_response(conn, 200)["data"] == %{
        "type" => "budget",
        "id" => "#{budget.id}",
        "attributes" => %{
          "name" => "Sample Budget",
          "description" => "This is a sample budget"
        },
        "links" => %{
          "self" => "/budgets/#{budget.id}"
        },
        "relationships" => %{
          "users" => %{
            "links" => %{
              "related" => "/budgets/#{budget.id}/users"
            }
          }
        }
      }
    end

    test "render error when queried budget is not associated with user", %{conn: conn} do
      budget = budget_fixture()
      conn = get conn, budget_path(conn, :show, budget.id)

      assert conn.status == 404
      assert json_response(conn, 404)["errors"] == [%{
        "title" => "Resource not found",
        "code" => 404
      }]
    end
  end

  describe "create budget" do
    test "renders budget when data is valid", %{conn: conn} do
      params = Poison.encode!(%{data: %{attributes: @create_attrs}})
      conn = post conn, budget_path(conn, :create), params
      response = json_response(conn, 201)["data"]

      assert response["attributes"] == %{
        "name" => "Sample Budget",
        "description" => "This is a sample budget"
      }
      assert length(response["relationships"]["users"]["data"]) == 1
    end

    test "renders errors when data is invalid", %{conn: conn} do
      params = %{data: %{attributes: @invalid_attrs}}
      conn = post conn, budget_path(conn, :create), params
      assert json_response(conn, 422)["errors"] == [%{
        "title" => "Unprocessable entity",
        "code" => 422
      }]
    end
  end

  describe "update budget" do
    setup [:create_budget]

    test "renders budget when data is valid", %{conn: conn, budget: budget} do
      user = Repo.get_by(User, email: "test@example.com")
      Budgets.associate_user_to_budget(budget, user)

      params = Poison.encode!(%{data: %{attributes: @update_attrs}})
      conn = put conn, budget_path(conn, :update, budget), params
      response = json_response(conn, 200)["data"]

      assert response["attributes"] == %{
        "name" => "Updated Sample Budget",
        "description" => "This is an updated sample budget"
      }
      assert length(response["relationships"]["users"]["data"]) == 1
    end

    test "renders errors when data is invalid", %{conn: conn, budget: budget} do
      user = Repo.get_by(User, email: "test@example.com")
      Budgets.associate_user_to_budget(budget, user)
      params = %{data: %{attributes: @invalid_attrs}}
      conn = put conn, budget_path(conn, :update, budget), params
      assert json_response(conn, 422)["errors"] == [%{
        "title" => "Unprocessable entity",
        "code" => 422
      }]
    end

    test "renders error when budget is not associated with current user", %{conn: conn, budget: budget} do
      params = %{data: %{attributes: @update_attrs}}
      conn = put conn, budget_path(conn, :update, budget), params
      assert json_response(conn, 404)["errors"] == [%{
        "title" => "Resource not found",
        "code" => 404
      }]
    end
  end

  describe "delete budget" do
    setup [:create_budget]

    test "deletes chosen budget", %{conn: conn, budget: budget} do
      user = Repo.get_by(User, email: "test@example.com")
      Budgets.associate_user_to_budget(budget, user)
      conn = delete conn, budget_path(conn, :delete, budget)
      assert response(conn, 204)
    end

    test "renders error when budget is not associated with current user", %{conn: conn, budget: budget} do
      conn = delete conn, budget_path(conn, :delete, budget)
      assert json_response(conn, 404)["errors"] == [%{
        "title" => "Resource not found",
        "code" => 404
      }]
    end
  end

  defp create_budget(_) do
    budget = budget_fixture()
    {:ok, budget: budget}
  end
end
