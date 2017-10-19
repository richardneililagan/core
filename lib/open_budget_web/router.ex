defmodule OpenBudgetWeb.Router do
  use OpenBudgetWeb, :router

  alias OpenBudgetWeb.EnsureAuthenticatedController, as: EnsureAuthenticated

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  pipeline :api_auth do
    plug :accepts, ["json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated, handler: EnsureAuthenticated
    plug Guardian.Plug.LoadResource
    plug JaSerializer.Deserializer
  end

  scope "/api", OpenBudgetWeb do
    pipe_through :api

    resources "/accounts", AccountController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
    resources "/budgets", BudgetController, except: [:new, :edit]
  end

  scope "/api/auth", OpenBudgetWeb do
    pipe_through :api

    resources "/token", TokenController, only: [:create]
    delete "/token", TokenController, :delete
  end
end
