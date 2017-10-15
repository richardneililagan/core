defmodule OpenBudget.Budgets.Budget do
  @moduledoc """
  Budgets are where most budget-related data should be associated with.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias OpenBudget.Budgets.Budget

  schema "budgets" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Budget{} = budget, attrs) do
    budget
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
