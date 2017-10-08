defmodule OpenBudgetWeb.EnsureAuthenticatedController do
  use OpenBudgetWeb, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(OpenBudgetWeb.ErrorView, "401.json-api")
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(403)
    |> render(OpenBudgetWeb.ErrorView, "403.json-api")
  end

  def already_authenticated(conn, _params) do
    conn
    |> put_status(200)
    |> render(OpenBudgetWeb.ErrorView, "200.json-api")
  end

  def no_resource(conn, _params) do
    conn
    |> put_status(404)
    |> render(OpenBudgetWeb.ErrorView, "404.json-api")
  end
end
