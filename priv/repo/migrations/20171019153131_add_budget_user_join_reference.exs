defmodule OpenBudget.Repo.Migrations.AddBudgetUserJoinReference do
  use Ecto.Migration

  def change do
    create table(:budgets_users, primary_key: false) do
      add :budget_id, references(:budgets)
      add :user_id, references(:users)
    end

    create unique_index(:budgets_users, [:budget_id, :user_id])
  end
end
