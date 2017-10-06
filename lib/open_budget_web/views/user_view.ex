defmodule OpenBudgetWeb.UserView do
  use OpenBudgetWeb, :view
  use JaSerializer.PhoenixView

  attributes [:email]
end
