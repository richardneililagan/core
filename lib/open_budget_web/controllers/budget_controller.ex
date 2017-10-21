defmodule OpenBudgetWeb.BudgetController do
  use OpenBudgetWeb, :controller

  alias OpenBudget.Repo
  alias OpenBudget.Budgets
  alias OpenBudget.Budgets.Budget
  alias JaSerializer.Params
  alias Guardian.Plug

  action_fallback OpenBudgetWeb.FallbackController

  def index(conn, _params) do
    current_user = Plug.current_resource(conn)
    budgets = Budgets.list_budgets(current_user)
    render(conn, "index.json-api", data: budgets)
  end

  def create(conn, %{"data" => data}) do
    attrs = Params.to_attributes(data)
    with {:ok, %Budget{} = budget} <-
        Budgets.create_budget(attrs) do
      current_user = Plug.current_resource(conn)
      Budgets.associate_user_to_budget(budget, current_user)
      budget =
        budget
        |> Repo.preload(:users)

      conn
      |> put_status(:created)
      |> put_resp_header("location", budget_path(conn, :show, budget))
      |> render("show.json-api", data: budget, opts: [include: "users"])
    end
  end

  def show(conn, %{"id" => id}) do
    budget = Budgets.get_budget!(id)
    render(conn, "show.json-api", data: budget)
  end

  def update(conn, %{"id" => id, "data" => data}) do
    budget = Repo.preload(Budgets.get_budget!(id), :users)
    attrs = Params.to_attributes(data)

    with {:ok, %Budget{} = budget} <-
        Budgets.update_budget(budget, attrs) do
      render(conn, "show.json-api", data: budget, opts: [include: "users"])
    end
  end

  def delete(conn, %{"id" => id}) do
    budget = Budgets.get_budget!(id)
    with {:ok, %Budget{}} <- Budgets.delete_budget(budget) do
      send_resp(conn, :no_content, "")
    end
  end
end
