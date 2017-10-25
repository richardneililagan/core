defmodule OpenBudget.Authentication.User do
  @moduledoc """
  User schema

  Representation of our users in the system.
  This is where we associate almost all of the
  data we have surrounding budgeting.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias OpenBudget.Authentication.User
  alias OpenBudget.Budgets.BudgetUser
  alias OpenBudget.Budgets.Budget
  alias Comeonin.Argon2

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    many_to_many :budgets, OpenBudget.Budgets.Budget,
                join_through: BudgetUser, unique: true
    belongs_to :active_budget, Budget

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, ~w(password), [])
    |> validate_length(:password, min: 6, max: 30)
    |> put_password_hash()
  end

  def active_budget_changeset(%User{} = user, attrs) do
    user |> cast(attrs, [:active_budget_id])
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Argon2.hashpwsalt(password))

      _ ->
        changeset
    end
  end
end
