defmodule OpenBudgetWeb.Router do
  use OpenBudgetWeb, :router

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  pipeline :api_auth do
    plug :accepts, ["json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated, handler: OpenBudgetWeb.EnsureAuthenticatedController
    plug Guardian.Plug.LoadResource
    plug JaSerializer.Deserializer
  end

  scope "/api", OpenBudgetWeb do
    pipe_through :api

    resources "/accounts", AccountController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
  end
end
