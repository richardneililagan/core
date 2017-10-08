defmodule OpenBudget.Authentication.Guardian do
  @moduledoc """
  Module required to map Guardian into OpenBudget
  """
  use Guardian, otp_app: :open_budget

  alias OpenBudget.Authentication
  alias OpenBudget.Authentication.User

  @doc """
  Encodes the User resource in a token for external use.

  Returns User:<id> if a valid user object was passed
  Returns {:error, :unknown_resource} if another resource has been passed

  ## Examples
      iex> subject_for_token(user, nil)
      {:ok, "User:123"}

      iex> subject_for_token(account, nil)
      {:error, :unknown_resource}

  """
  def subject_for_token(%User{} = user, _claims) do
    {:ok, "User:" <> to_string(user.id)}
  end

  def subject_for_token(_, _) do
    {:error, :unknown_resource}
  end

  @doc """
  Decodes the User resource from claims for internal use.

  Returns {:ok, %User{}} if ID matches an existing user record
  Returns {:error, :invalid_id} if ID is not in the correct ID format
  Returns {:error, :no_result} if ID did not match any user record
  Returns {:error, :invalid_claims} if another resource is passed instead of User

  ## Examples
      iex> resource_from_claims(%{"sub" => "User:123"})
      {:ok, %User{}}

      iex> resource_from_claims(%{"sub" => "User:1a2b3c"})
      {:error, :invalid_id}

      iex> resource_from_claims(%{"sub" => "User:999999"})
      {:error, :no_result}

      iex> resource_from_claims(%{"sub" => "Account:123"})
      {:error, :invalid_claims}
  """
  def resource_from_claims(%{"sub" => "User:" <> uid_str}) do
    case Integer.parse(uid_str) do
      {uid, ""} ->
        {:ok, Authentication.get_user!(uid)}
      _ ->
        {:error, :invalid_id}
    end
  rescue
    Ecto.NoResultsError -> {:error, :no_result}
  end

  def resource_from_claims(_claims) do
    {:error, :invalid_claims}
  end
end
