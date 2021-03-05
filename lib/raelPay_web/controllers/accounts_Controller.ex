defmodule RaelPayWeb.AccountsController do
  use RaelPayWeb, :controller

  alias RaelPay.Account

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
end
