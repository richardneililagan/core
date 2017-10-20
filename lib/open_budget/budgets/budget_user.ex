defmodule OpenBudget.Budgets.BudgetUser do
  @moduledoc """
  This is the join table for Budgets and Users
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias OpenBudget.Budgets.Budget
  alias OpenBudget.Budgets.BudgetUser
  alias OpenBudget.Authentication.User

  @primary_key false
  schema "budgets_users" do
    belongs_to :budget, Budget
    belongs_to :user, User
  end

  def changeset(%BudgetUser{} = budget_user, attrs \\ %{}) do
    budget_user
    |> cast(attrs, [:budget_id, :user_id])
    |> validate_required([:budget_id, :user_id])
  end
end
