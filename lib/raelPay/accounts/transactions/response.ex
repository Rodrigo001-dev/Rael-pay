# esse arquivo qu vai cuidar de guardar a informação da transação
defmodule RaelPay.Accounts.Transaction.Response do
  alias RaelPay.Account

  defstruct [:from_account, :to_account]

  def build(%Account{} = from_account, %Account{} = to_account) do
    # esse %__MODULE__{} é como se eu estivesse escrevendo o nome do modulo
    # inteiro(RaelPay.Accounts.Transaction.Response)
    %__MODULE__{
      from_account: from_account,
      to_account: to_account
    }
  end
end
