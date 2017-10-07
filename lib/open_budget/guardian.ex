defmodule OpenBudget.Guardian do
  @moduledoc """
  Module required by Guardian to work
  """
  use Guardian, otp_app: :open_budget

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    {:ok, find_me_a_resource(claims["sub"])}
  end
  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end