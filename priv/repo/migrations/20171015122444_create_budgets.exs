defmodule OpenBudget.Repo.Migrations.CreateBudgets do
  use Ecto.Migration

  def change do
    create table(:budgets) do
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
