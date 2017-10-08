defmodule OpenBudgetWeb.TokenController do
  use OpenBudgetWeb, :controller

  alias OpenBudget.Authentication.Guardian
  import OpenBudgetWeb.Authentication

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)

    case sign_in_by_email_and_password(conn, attrs) do
      {:ok, conn} ->
        token = Guardian.Plug.current_token(conn)

        conn
        |> put_resp_header("authorization", "Bearer #{token}")
        |> json(%{access_token: token})
      {:error, :unauthorized, conn} ->
        conn
        |> put_status(401)
        |> render(OpenBudgetWeb.ErrorView, "401.json-api")
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out() 
    |> send_resp(:no_content, "")
  end
end