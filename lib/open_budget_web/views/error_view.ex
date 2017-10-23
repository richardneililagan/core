defmodule OpenBudgetWeb.ErrorView do
  use OpenBudgetWeb, :view
  use JaSerializer.PhoenixView

  alias JaSerializer.ErrorSerializer

  def render("401.json-api", _assigns) do
    %{title: "Unauthorized", status: 401, detail: "You are not authorized to access this resource"}
    |> ErrorSerializer.format
  end

  def render("403.json-api", _assigns) do
    %{title: "Forbidden", status: 403, detail: "Accessing this resource is forbidden"}
    |> ErrorSerializer.format
  end

  def render("404.json-api", _assigns) do
    %{title: "Resource not found", status: 404, detail: "This resource cannot be found"}
    |> ErrorSerializer.format
  end

  def render("422.json-api", _assigns) do
    %{title: "Unprocessable entity", status: 422, detail: "There is an error with processing this resource"}
    |> ErrorSerializer.format
  end

  def render("500.json-api", _assigns) do
    %{title: "Internal server error", status: 500, detail: "An unexpected error happened on the server"}
    |> ErrorSerializer.format
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json-api", assigns
  end
end
