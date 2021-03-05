defmodule RaelPay.Accounts.Operation do
  alias Ecto.Multi

  alias RaelPay.{Account}

  def call(%{"id" => id, "value" => value}, operation) do
    operation_name = account_operation_name(operation)

    Multi.new()
    |> Multi.run(operation_name, fn repo, _changes -> get_account(repo, id) end)
    |> Multi.run(operation, fn repo, changes ->
      account = Map.get(changes, operation_name)

      update_balance(repo, account, value, operation)
    end)
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

  defp update_balance(repo, account, value, operation) do
    # vai pegar a conta
    account
    # vai somar o valor da conta com o value
    |> operation(value, operation)
    # essa função(update_account) vai receber o repo e o valor(operation)
    # ai essa função vai atualizar o saldo(balance)
    |> update_account(repo, account)
  end

  # essa função recebe uma conta com o saldo(balance) dela e o valoe que eu
  # inserir
  defp operation(%Account{balance: balance}, value, operation) do
    # pegando o valor
    value
    # vai tentar transformar o valor em decimal
    |> Decimal.cast()
    # essa função vai lidar com o valor do cast
    |> handle_cast(balance, operation)
  end

  # se eu receber um ok e um valor quer dizer que eu posso somar esses valores
  # a função Decimal.add() vai somar dois decimais
  # se eu receber uma operation deposit eu chamo Decimal.add() para somar os
  # valores
  defp handle_cast({:ok, value}, balance, :deposit), do: Decimal.add(balance, value)
  # se eu recever uma operation withdraw eu chamo Decimal.sub() que vai subtrair
  # os valores
  defp handle_cast({:ok, value}, balance, :withdraw), do: Decimal.sub(balance, value)
  # caso eu receba um error eu vou devolver um erro para o usuário
  defp handle_cast(:error, _balance, _operation), do: {:error, "Invalid deposit value!"}

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

  defp account_operation_name(operation) do
    # eu estou pegando uma String account_ e estou concatenando com a
    # interpolação de String a operação
    "account_#{Atom.to_string(operation)}" |> String.to_atom()
  end
end
