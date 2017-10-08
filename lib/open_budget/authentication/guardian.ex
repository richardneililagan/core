defmodule OpenBudget.Authentication.Guardian do
  @moduledoc """
  Module required by Guardian to work
  """
  use Guardian, otp_app: :open_budget

  alias OpenBudget.Authentication
  alias OpenBudget.Authentication.User

  def subject_for_token(%User{} = user, _claims) do
    {:ok, "User:" <> to_string(user.id)}
  end

  def subject_for_token(_, _) do
    {:error, :unknown_resource}
  end

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
