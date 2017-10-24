defmodule OpenBudget.Repo.Migrations.AddActiveBudgetToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :active_budget_id, references(:budgets)
    end
  end
end
