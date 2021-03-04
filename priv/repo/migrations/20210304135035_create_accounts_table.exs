defmodule RaelPay.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table :accounts do
      add :balance, :decimal
      add :user_id, references(:users, type: :binary_id)

      timestamps()
    end

    # as constraint são formas de trazer uma lógica para a tabela, extender as
    # funcionalidade dos dados, proteções, entre outros
    # estou falando que o saldo não pode ser menor que 0(não pode ser negativo)
    create constraint(:accounts, :balance_must_be_positive_or_zero, check: "balance >= 0")
  end
end
