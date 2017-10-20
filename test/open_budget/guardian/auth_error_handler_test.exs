defmodule OpenBudget.Guardian.AuthErrorHandlerTest do
  use OpenBudgetWeb.ConnCase

  alias OpenBudget.Guardian.AuthErrorHandler

  describe("#auth_error") do
    test "sends 401 resp with {message: <type>} json as body", %{conn: conn} do
      conn = AuthErrorHandler.auth_error(conn, {:unauthorized, nil}, nil)
      resp_body = Poison.encode!(%{jsonapi: %{version: "1.0"}, errors: [%{title: "Unauthorized", code: 401}]})

      assert conn.status == 401
      assert conn.resp_body == resp_body
    end
  end
end
