defmodule RaelPay.Repo.Migrations.CreateUserTable do
  use Ecto.Migration

  # quando é criado qualquer operação dentro do change essa operação já fica
  # pronta para ser criada ou para fazer o roll back
  def change do
    # criando a tabela de usuários
    create table :users do
      # adicionando uma coluna name do tipo string
      add :name, :string
      # adicionando uma coluna age do tipo integer
      add :age, :integer
      add :email, :string
      add :password_hash, :string
      add :nickname, :string

      # quando é chamado a função timestamps() ela vai colocar mais duas colunas
      # a inserted_at e a updated_at
      timestamps()
    end

    # estou criando um index de email unico para cada usuário, ou seja, 2
    # usuários não podem ter o memso email
    create unique_index(:users, [:email])
    # estou criando um index de nickname unico para cada usuário, ou seja, 2
    # usuários não podem ter o memso nickname
    create unique_index(:users, [:nickname])
  end
end
