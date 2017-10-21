defmodule OpenBudgetWeb.UserView do
  use OpenBudgetWeb, :view
  use JaSerializer.PhoenixView

  location "/users/:id"
  attributes [:email]
end
