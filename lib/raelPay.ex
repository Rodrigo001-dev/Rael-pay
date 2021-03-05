defmodule RaelPay do
  alias RaelPay.Users.Create, as: UserCreate

  alias RaelPay.Accounts.{Deposit, Transaction, Withdraw}

  # aqui eu estou criando uma fachada, ou seja, todo o usuário da minha
  # aplicação vai conhecer só esse modulo (RaelPay)
  # esse as: quer dizer que eu estou chamando a função call
  defdelegate create_user(params), to: UserCreate, as: :call

  defdelegate deposit(params), to: Deposit, as: :call
  defdelegate withdraw(params), to: Withdraw, as: :call
  defdelegate transaction(params), to: Transaction, as: :call
end
