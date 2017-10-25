defmodule OpenBudgetWeb.BudgetController do
  use OpenBudgetWeb, :controller

  alias OpenBudget.Repo
  alias OpenBudget.Budgets
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
    current_user = Plug.current_resource(conn)
    case Budgets.create_budget(attrs, current_user) do
      {:ok, budget} ->
        conn
        |> put_status(201)
        |> render("show.json-api", data: budget, opts: [include: "users"])
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(OpenBudgetWeb.ErrorView, "422.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = Plug.current_resource(conn)
    case Budgets.get_budget(id, current_user) do
      {:ok, budget} -> render(conn, "show.json-api", data: budget)
      {:error, _} ->
        conn
        |> put_status(404)
        |> render(OpenBudgetWeb.ErrorView, "404.json-api")
    end
  end

  def update(conn, %{"id" => id, "data" => data}) do
    current_user = Plug.current_resource(conn)
    case Budgets.get_budget(id, current_user) do
      {:ok, budget} ->
        budget = Repo.preload(budget, :users)
        attrs = Params.to_attributes(data)

        case Budgets.update_budget(budget, attrs) do
          {:ok, budget} -> render(conn, "show.json-api", data: budget, opts: [include: "users"])
          {:error, changeset} ->
            conn
            |> put_status(422)
            |> render(OpenBudgetWeb.ErrorView, "422.json-api", changeset: changeset)
        end
      {:error, _} ->
        conn
        |> put_status(404)
        |> render(OpenBudgetWeb.ErrorView, "404.json-api")
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = Plug.current_resource(conn)
    case Budgets.get_budget(id, current_user) do
      {:ok, budget} ->
        case Budgets.delete_budget(budget) do
          {:ok, _} -> send_resp(conn, :no_content, "")
        end
      {:error, _} ->
        conn
        |> put_status(404)
        |> render(OpenBudgetWeb.ErrorView, "404.json-api")
    end
  end

  def switch(conn, %{"budget_id" => id}) do
    current_user = Plug.current_resource(conn)
    case Budgets.get_budget(id, current_user) do
      {:ok, budget} ->
        {:ok, budget, _} = Budgets.switch_active_budget(budget, current_user)
        render(conn, "show.json-api", data: budget)
      {:error, _} ->
        conn
        |> put_status(404)
        |> render(OpenBudgetWeb.ErrorView, "404.json-api")
    end
  end
end
