defmodule OpenBudgetWeb.AccountController do
  use OpenBudgetWeb, :controller

  alias OpenBudget.Budgets
  alias OpenBudget.Budgets.Account

  action_fallback OpenBudgetWeb.FallbackController

  def index(conn, _params) do
    accounts = Budgets.list_accounts()
    render(conn, "index.json", accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <-
      Budgets.create_account(account_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", account_path(conn, :show, account))
      |> render("show.json", account: account)
    end
  end

  def show(conn, %{"id" => id}) do
    account = Budgets.get_account!(id)
    render(conn, "show.json", account: account)
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Budgets.get_account!(id)

    with {:ok, %Account{} = account} <-
      Budgets.update_account(account, account_params) do
      render(conn, "show.json", account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Budgets.get_account!(id)
    with {:ok, %Account{}} <- Budgets.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
