defmodule RaelPayWeb.AccountsController do
  use RaelPayWeb, :controller

  alias RaelPay.Account
  alias RaelPay.Accounts.Transaction.Response, as: TransactionResponse

  action_fallback RaelPayWeb.FallbackController

  def deposit(conn, params) do
    with {:ok, %Account{} = account} <- RaelPay.deposit(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  def withdraw(conn, params) do
    with {:ok, %Account{} = account} <- RaelPay.withdraw(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    end
  end

  def transaction(conn, params) do
    with {:ok, %TransactionResponse{} = transaction} <- RaelPay.transaction(params) do
      conn
      |> put_status(:ok)
      |> render("transaction.json", transaction: transaction)
    end
  end
end
