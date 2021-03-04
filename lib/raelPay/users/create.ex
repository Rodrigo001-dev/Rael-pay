defmodule RaelPay.Users.Create do
  # Repo é o modulo que conversa com o banco da dados
  # criando um alias para poder utilizar o Multi(multi operação)
  alias Ecto.Multi
  alias RaelPay.{Account, Repo, User}

  # essa função vai fazer a inserção dos dados no banco da dados
  def call(params) do
    # estou começando uma multi operação
    Multi.new()
    # sempre quando eu crio uma operação Multi eu tenho que dar um nome para ela
    # como primeiro parâmetro
    # o segundo parâmetro é porque o insert espera um changeset
    |> Multi.insert(:create_user, User.changeset(params))
    # o Multi.run() permite que eu faça qualquer operação no meu banco de dados
    # com o Repo só que ele permite que eu leia o resultado da operação anterior
    # através do nome que eu dei para ela
    # o segundo parâmetro que o Multi.run() espera é sempre uma função anônima
    |> Multi.run(:create_account, fn repo, %{create_user: user} ->
      insert_account(repo, user)
    end)
    # estou fazendo isso para pegar o id do usuário e a conta(account)
    |> Multi.run(:preload_data, fn repo, %{create_user: user} ->
      preload_data(repo, user)
    end)
    |> run_transaction()

    # params
    #   |> User.changeset
    #   |> Repo.insert()
  end

  defp insert_account(repo, user) do
    user.id
    |> account_changeset()
    |> repo.insert()
  end

  defp account_changeset(user_id) do
    params = %{user_id: user_id, balance: "0.00"}

    Account.changeset(params)
  end

  defp preload_data(repo, user) do
    # vai devolver o usuário com a conta carregada
    {:ok, repo.preload(user, :account)}
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      # se eu receber um error, o nome da operação(operation), os motivos de
      # erro(reason) e quais changes eu executei eu vou devolver o erro
      {:error, _operation, reason, _changes} -> {:error, reason}
      # se eu receber um ok e um mapa(%{}) como nome da ultima
      # operação(create_account)
      {:ok, %{preload_data: user}} -> {:ok, user}
    end
  end
end
