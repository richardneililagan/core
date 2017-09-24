defmodule OpenBudgetWeb.AccountController do
  use OpenBudgetWeb, :controller

  alias OpenBudget.Budgets
  alias OpenBudget.Budgets.Account

  action_fallback OpenBudgetWeb.FallbackController

  def index(conn, _params) do
    accounts = Budgets.list_accounts()
    render(conn, "index.json-api", data: accounts)
  end

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    with {:ok, %Account{} = account} <-
      Budgets.create_account(attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", account_path(conn, :show, account))
      |> render("show.json-api", data: account)
    end
  end

  def show(conn, %{"id" => id}) do
    account = Budgets.get_account!(id)
    render(conn, "show.json-api", data: account)
  end

  def update(conn, %{"id" => id, "data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    account = Budgets.get_account!(id)

    with {:ok, %Account{} = account} <-
      Budgets.update_account(account, attrs) do
      render(conn, "show.json-api", data: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Budgets.get_account!(id)
    with {:ok, %Account{}} <- Budgets.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
