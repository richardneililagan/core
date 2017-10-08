defmodule OpenBudgetWeb.Authentication do
  @moduledoc """
  Module containing the different methods for authenticating users
  """
  import Comeonin.Argon2, only: [checkpw: 2, dummy_checkpw: 0]

  alias OpenBudget.Repo
  alias OpenBudget.Authentication.User

  @doc """
  Authenticates a user using an email and password combination

  ## Examples
      iex> sign_in_by_email_and_password(conn, %{"email" => "valid@example.com", "password" => "secretpass"})
      {:ok, conn}

      iex> sign_in_by_email_and_password(conn, %{"email" => "invalid@example.com", "password" => "secretpass"})
      {:error, :unauthorized, conn}
  """
  def sign_in_by_email_and_password(conn, %{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: email)

    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, sign_in(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  defp sign_in(conn, user) do
    conn
    |> OpenBudget.Authentication.Guardian.Plug.sign_in(user)
  end
end