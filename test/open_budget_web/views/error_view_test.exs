defmodule OpenBudgetWeb.ErrorViewTest do
  use OpenBudgetWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 401.json-api" do
    assert render(OpenBudgetWeb.ErrorView, "401.json-api", []) ==
           %{
             "errors" => [%{code: 401, title: "Unauthorized"}],
             "jsonapi" => %{"version" => "1.0"}
            }
  end

  test "renders 403.json-api" do
    assert render(OpenBudgetWeb.ErrorView, "403.json-api", []) ==
           %{
             "errors" => [%{code: 403, title: "Forbidden"}],
             "jsonapi" => %{"version" => "1.0"}
            }
  end

  test "renders 404.json-api" do
    assert render(OpenBudgetWeb.ErrorView, "404.json-api", []) ==
           %{
             "errors" => [%{code: 404, title: "Resource not found"}],
             "jsonapi" => %{"version" => "1.0"}
            }
  end

  test "renders 422.json-api" do
    assert render(OpenBudgetWeb.ErrorView, "422.json-api", []) ==
           %{
             "errors" => [%{code: 422, title: "Unprocessable entity"}],
             "jsonapi" => %{"version" => "1.0"}
            }
  end

  test "render 500.json-api" do
    assert render(OpenBudgetWeb.ErrorView, "500.json-api", []) ==
           %{
             "errors" => [%{code: 500, title: "Internal server error"}],
             "jsonapi" => %{"version" => "1.0"}
            }
  end

  test "render any other" do
    assert render(OpenBudgetWeb.ErrorView, "505.json", []) ==
           %{
             "errors" => [%{code: 500, title: "Internal server error"}],
             "jsonapi" => %{"version" => "1.0"}
            }
  end
end
