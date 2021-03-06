# cada request que um controller recebe em elixir é um processo executado
# separadamente
# um processo do sistema operacional normalmente é caro de ser criado então a
# maquina virtual está rodando sobre um processo só que a
# bin(a maquina virtual do erlang) ela tem seus próprios processo que são leves,
# rápidos, consomem pouca memória e eles podem ser criados aos milhares, então
# cada request que é feito para a nossa aplicação é um novo processo do bin
# que é criado, então mesmo que um processo se quebre, de exceção, que dê um erro,
# qualquer coisa desse tipo não vai afetar os outros processos

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
    # utilizando tasks
    task = Task.async(fn -> RaelPay.transaction(params) end)

    with {:ok, %TransactionResponse{} = transaction} <- Task.await(task) do
      conn
      |> put_status(:ok)
      |> render("transaction.json", transaction: transaction)
    end
  end
end
