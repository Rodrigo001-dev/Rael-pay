defmodule RaelPay.Users.Create do
  # Repo é o modulo que conversa com o banco da dados
  alias RaelPay.{Repo, User}

  # essa função vai fazer a inserção dos dados no banco da dados
  def call(params) do
    params
      |> User.changeset
      |> Repo.insert()
  end
end
