defmodule OpenBudgetWeb.UserController do
  use OpenBudgetWeb, :controller

  alias OpenBudget.Authentication
  alias OpenBudget.Authentication.User
  alias JaSerializer.Params

  action_fallback OpenBudgetWeb.FallbackController

  def index(conn, _params) do
    users = Authentication.list_users()
    render(conn, "index.json-api", data: users)
  end

  def create(conn, %{"data" => data}) do
    attrs = Params.to_attributes(data)
    with {:ok, %User{} = user} <-
        Authentication.create_user(attrs) do
      conn
      |> put_status(:created)
      |> render("show.json-api", data: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Authentication.get_user!(id)
    render(conn, "show.json-api", data: user)
  end

  def update(conn, %{"id" => id, "data" => data}) do
    user = Authentication.get_user!(id)
    attrs = Params.to_attributes(data)

    with {:ok, %User{} = user} <-
        Authentication.update_user(user, attrs) do
      render(conn, "show.json-api", data: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Authentication.get_user!(id)
    with {:ok, %User{}} <- Authentication.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
