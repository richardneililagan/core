defmodule OpenBudgetWeb.ErrorViewTest do
  use OpenBudgetWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 401.json-api" do
    assert render(OpenBudgetWeb.ErrorView, "401.json-api", []) ==
           %{
             "errors" => [%{
               status: 401,
               title: "Unauthorized",
               detail: "You are not authorized to access this resource"
              }],
             "jsonapi" => %{"version" => "1.0"}
            }
  end

  test "renders 403.json-api" do
    assert render(OpenBudgetWeb.ErrorView, "403.json-api", []) ==
           %{
             "errors" => [%{
               status: 403,
               title: "Forbidden",
               detail: "Accessing this resource is forbidden"
              }],
             "jsonapi" => %{"version" => "1.0"}
            }
  end

  test "renders 404.json-api" do
    assert render(OpenBudgetWeb.ErrorView, "404.json-api", []) ==
           %{
             "errors" => [%{
               status: 404,
               title: "Resource not found",
               detail: "This resource cannot be found"
              }],
             "jsonapi" => %{"version" => "1.0"}
            }
  end

  test "renders 422.json-api" do
    assert render(OpenBudgetWeb.ErrorView, "422.json-api", []) ==
           %{
             "errors" => [%{
               status: 422,
               title: "Unprocessable entity",
               detail: "There is an error with processing this resource"
              }],
             "jsonapi" => %{"version" => "1.0"}
            }
  end

  test "render 500.json-api" do
    assert render(OpenBudgetWeb.ErrorView, "500.json-api", []) ==
           %{
             "errors" => [%{
               status: 500,
               title: "Internal server error",
               detail: "An unexpected error happened on the server"
              }],
             "jsonapi" => %{"version" => "1.0"}
            }
  end

  test "render any other" do
    assert render(OpenBudgetWeb.ErrorView, "505.json", []) ==
           %{
             "errors" => [%{
               status: 500,
               title: "Internal server error",
               detail: "An unexpected error happened on the server"
              }],
             "jsonapi" => %{"version" => "1.0"}
            }
  end
end
