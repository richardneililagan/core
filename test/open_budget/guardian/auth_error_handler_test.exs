defmodule OpenBudget.Guardian.AuthErrorHandlerTest do
  use OpenBudgetWeb.ConnCase

  alias OpenBudget.Guardian.AuthErrorHandler

  describe("#auth_error") do
    test "sends 401 resp with {message: <type>} json as body", %{conn: conn} do
      conn = AuthErrorHandler.auth_error(conn, {:unauthorized, nil}, nil)
      body = %{
        jsonapi: %{version: "1.0"},
        errors: [%{
          title: "Unauthorized",
          status: 401,
          detail: "You are not authorized to access this resource"
        }]
      }
      resp_body = Poison.encode!(body)

      assert conn.status == 401
      assert conn.resp_body == resp_body
    end
  end
end
