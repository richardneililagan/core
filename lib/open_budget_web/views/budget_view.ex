defmodule OpenBudgetWeb.BudgetView do
  use OpenBudgetWeb, :view
  use JaSerializer.PhoenixView

  location "/budgets/:id"
  attributes [:name, :description]

  has_many :users,
    serializer: OpenBudgetWeb.UserView,
    include: false,
    identifiers: :when_included,
    links: [
      related: "/budgets/:id/users"
    ]
end
