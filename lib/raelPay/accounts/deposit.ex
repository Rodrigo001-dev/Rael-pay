defmodule RaelPay.Accounts.Deposit do
  alias Ecto.Multi

  alias RaelPay.{Account, Repo}

  def call(%{"id" => id, "value" => value}) do
    Multi.new()
    |> Multi.run(:account, fn repo, _changes -> get_account(repo, id) end)
    |> Multi.run(:update_balance, fn repo, %{account: account} ->
      update_balance(repo, account, value)
    end)
    |> run_transaction()
  end

  defp get_account(repo, id) do
    case repo.get(Account, id) do
      # caso o meu repo.get me retorne nil(nulo) que quer dizer que ele não
      # encontrou ninhuma conta com esse id no banco de dados, então vou
      # devolver um error
      nil -> {:error, "Account not found!"}
      # e se eu receber uma conta eu vou devolver um ok e um account
      account -> {:ok, account}
    end
  end

  defp update_balance(repo, account, value) do
    # vai pegar a conta
    account
    # vai somar o valor da conta com o value
    |> sum_values(value)
    # essa função(update_account) vai receber o repo e o valor da soma(sum_values)
    # ai essa função vai atualizar o saldo(balance)
    |> update_account(repo, account)
  end

  # essa função recebe uma conta com o saldo(balance) dela e o valoe que eu
  # inserir
  defp sum_values(%Account{balance: balance}, value) do
    # pegando o valor
    value
    # vai tentar transformar o valor em decimal
    |> Decimal.cast()
    # essa função vai lidar com o valor do cast
    |> handle_cast(balance)
  end

  # se eu receber um ok e um valor quer dizer que eu posso somar esses valores
  # a função Decimal.add() vai somar dois decimais
  defp handle_cast({:ok, value}, balance), do: Decimal.add(balance, value)
  # caso eu receba um error eu vou devolver um erro para o usuário
  defp handle_cast(:error, _balance), do: {:error, "Invalid deposit value!"}

  defp update_account({:error, _reason} = error, _repo, _account), do: error
  defp update_account(value, repo, account) do
    params = %{balance: value}

    # primeiro eu passo a struct que eu li no passo 1(update_balance) e depois
    # os parâmetros
    account
    # passando a conta(account) o Ecto vai saber que é uma atualização
    |> Account.changeset(params)
    |> repo.update()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{update_balance: account}} -> {:ok, account}
    end
  end
end
