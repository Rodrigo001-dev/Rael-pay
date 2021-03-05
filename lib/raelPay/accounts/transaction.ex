defmodule RaelPay.Accounts.Transaction do
  alias Ecto.Multi

  alias RaelPay.Repo
  alias RaelPay.Accounts.Transaction.Response, as: TransactionResponse
  alias RaelPay.Accounts.Operation

  # em uma transação é preciso de o id de quem está enviando(from_id), o id de
  # que está recebendo(to_id) e o valor da operação
  def call(%{"from" => from_id, "to" => to_id, "value" => value}) do
    withdraw_params = build_params(from_id, value)
    deposit_params = build_params(to_id, value)

    Multi.new()
    # se eu deixasse somente o Multi.new iria dar erro por causa que eu tenho
    # o Multi executando na Operation e por causa disso que eu usso o
    # Multi.merge() que vai ver outros Multis
    |> Multi.merge(fn _changes -> Operation.call(withdraw_params, :withdraw) end)
    |> Multi.merge(fn _changes -> Operation.call(deposit_params, :deposit) end)
    |> run_transaction()
  end

  # tanto o deposito quando o saque experam um map com o id e o
  #  valor(%{"id" => id, "value" => value})
  defp build_params(id, value), do: %{"id" => id, "value" => value}

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{deposit: to_account, withdraw: from_account}} ->
        {:ok, TransactionResponse.build(from_account, to_account)}
    end
  end
end
