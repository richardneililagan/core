defmodule OpenBudget.Guardian.AuthPipeline do
  @moduledoc """
  Pipeline for Guardian
  """
  alias OpenBudgetWeb.EnsureAuthenticatedController, as: EnsureAuthenticated
  alias OpenBudget.Guardian.AuthErrorHandler

  use Guardian.Plug.Pipeline, otp_app: :open_budget,
                              module: OpenBudget.Authentication.Guardian,
                              error_handler: AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated, handler: EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
