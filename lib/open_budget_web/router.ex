defmodule OpenBudgetWeb.Router do
  use OpenBudgetWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", OpenBudgetWeb do
    pipe_through :api
  end
end
