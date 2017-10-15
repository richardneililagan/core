defmodule OpenBudget.BudgetsTest do
  use OpenBudget.DataCase

  alias OpenBudget.Budgets

  describe "accounts" do
    alias OpenBudget.Budgets.Account

    @valid_attrs %{description: "some description", name: "some name", category: "some type"}
    @update_attrs %{description: "some updated description", name: "some updated name", category: "some updated type"}
    @invalid_attrs %{description: nil, name: nil, type: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Budgets.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Budgets.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Budgets.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Budgets.create_account(@valid_attrs)
      assert account.description == "some description"
      assert account.name == "some name"
      assert account.category == "some type"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Budgets.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, account} = Budgets.update_account(account, @update_attrs)
      assert %Account{} = account
      assert account.description == "some updated description"
      assert account.name == "some updated name"
      assert account.category == "some updated type"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Budgets.update_account(account, @invalid_attrs)
      assert account == Budgets.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Budgets.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Budgets.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Budgets.change_account(account)
    end
  end

  describe "budgets" do
    alias OpenBudget.Budgets.Budget

    @valid_attrs %{name: "Sample Budget", description: "This is a sample budget"}
    @update_attrs %{name: "Updated Sample Budget", description: "This is an updated sample budget"}
    @invalid_attrs %{name: nil, description: nil}

    def budget_fixture(attrs \\ %{}) do
      {:ok, budget} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Budgets.create_budget()

      budget
    end

    test "list_budgets/0 returns all budgets" do
      budget = budget_fixture()
      assert Budgets.list_budgets() == [budget]
    end

    test "get_budget!/1 returns the budget with given id" do
      budget = budget_fixture()
      assert Budgets.get_budget!(budget.id) == budget
    end

    test "create_budget/1 with valid data creates a budget" do
      assert {:ok, %Budget{} = budget} = Budgets.create_budget(@valid_attrs)
      assert budget.name == "Sample Budget"
      assert budget.description == "This is a sample budget"
    end

    test "create_budget/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Budgets.create_budget(@invalid_attrs)
    end

    test "update_budget/2 with valid data updates the budget" do
      budget = budget_fixture()
      assert {:ok, budget} = Budgets.update_budget(budget, @update_attrs)
      assert %Budget{} = budget
      assert budget.name == "Updated Sample Budget"
      assert budget.description == "This is an updated sample budget"
    end

    test "update_budget/2 with invalid data returns error changeset" do
      budget = budget_fixture()
      assert {:error, %Ecto.Changeset{}} = Budgets.update_budget(budget, @invalid_attrs)
      assert budget == Budgets.get_budget!(budget.id)
    end

    test "delete_budget/1 deletes the budget" do
      budget = budget_fixture()
      assert {:ok, %Budget{}} = Budgets.delete_budget(budget)
      assert_raise Ecto.NoResultsError, fn -> Budgets.get_budget!(budget.id) end
    end

    test "change_budget/1 returns a budget changeset" do
      budget = budget_fixture()
      assert %Ecto.Changeset{} = Budgets.change_budget(budget)
    end
  end
end
