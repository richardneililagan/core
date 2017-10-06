defmodule OpenBudget.Authentication.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias OpenBudget.Authentication.User


  schema "users" do
    field :email, :string
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash])
    |> validate_required([:email, :password_hash])
    |> unique_constraint(:email)
  end
end
