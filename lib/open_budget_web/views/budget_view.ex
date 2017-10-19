defmodule OpenBudgetWeb.BudgetView do
  use OpenBudgetWeb, :view
  use JaSerializer.PhoenixView

  attributes [:name, :description]
end
