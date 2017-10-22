defmodule OpenBudgetWeb.TokenController do
  use OpenBudgetWeb, :controller

  alias OpenBudget.Guardian.Plug
  alias JaSerializer.Params
  import OpenBudget.Guardian.Authentication

  def create(conn, %{"data" => data}) do
    attrs = Params.to_attributes(data)

    case sign_in_by_email_and_password(conn, attrs) do
      {:ok, conn} ->
        token = Plug.current_token(conn)

        conn
        |> put_status(201)
        |> put_resp_header("authorization", "Bearer #{token}")
        |> json(%{access_token: token})
      {:error, :unauthorized, conn} ->
        conn
        |> put_status(401)
        |> render(OpenBudgetWeb.ErrorView, "401.json-api")
      {:error, :not_found, conn} ->
        conn
        |> put_status(404)
        |> render(OpenBudgetWeb.ErrorView, "404.json-api")
    end
  end

  def delete(conn, _) do
    conn
    |> Plug.sign_out()
    |> send_resp(:no_content, "")
  end
end
