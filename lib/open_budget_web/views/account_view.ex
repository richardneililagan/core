defmodule OpenBudgetWeb.AccountView do
  use OpenBudgetWeb, :view
  use JaSerializer.PhoenixView

  attributes [:name, :description, :category]
end
