defmodule OpenBudget.Budgets.Account do
  @moduledoc """
  Accounts are the representation
  of a user's real-life accounts.

  ## Examples

      Petty Cash
      BPI Savings
      BDO Checking
      HSBC Visa
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias OpenBudget.Budgets.Account

  schema "accounts" do
    field :description, :string
    field :name, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:name, :description, :type])
    |> validate_required([:name, :description, :type])
  end
end
