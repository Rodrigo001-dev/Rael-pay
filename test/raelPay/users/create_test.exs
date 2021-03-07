defmodule RaelPay.Users.CreateTest do
  # eu estou utilizando o DataCase porque ele tem uma função chamada errors_on
  # que extrai os erros, ou seja, o erro vai ficar mais explícito e tmabém estou
  # utilizando porque ele configura o meu banco de dados em Sandbox em ambiente
  # de teste, ou seja, quando eu executo os testes é criado tudo no banco mas
  # quando todos os testes acabam de executar ele dá o rollback e deixa o meu
  # banco limpo
  use RaelPay.DataCase, async: true

  alias RaelPay.User
  alias RaelPay.Users.Create

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = %{
        name: "Rodrigo",
        password: "123456",
        nickname: "RaelRodrigo001",
        email: "rodrigorael53@gmail.com",
        age: 18
      }

      # para saber se o usuário foi realmente criado no banco de dados de testes
      # eu vou mandar criar o usuário, vou pegar o id dele vou ler ele no banco
      # e vou ver se ele existe
      {:ok, %User{id: user_id}} = Create.call(params)
      # com o Repo.get() vou ler do banco de dados um tipo de dado que eu
      # específico como primeiro argumento(User) e o segundo argumento é o id
      # desse tipo de dado(user_id)
      user = Repo.get(User, user_id)

      # o ^ é o pin operator. o pin operator pega um valor pré estabelecido
      # antes e fixa esse valor, ou seja, se o user_id valer 555 onde eu coloquei
      # o pin operator sempre vai valer 555(^user_id), nunca vai alterar o valor
      # eu estou utilizando o pipe operator porque o id é algo que não tem como
      # eu saber por ele ser um uuid e ser gerado automaticamente
      assert %User{name: "Rodrigo", age: 18, id: ^user_id} = user
    end

    test "when there are invalid params, returns an error" do
      params = %{
        name: "Rodrigo",
        nickname: "RaelRodrigo001",
        email: "rodrigorael53@gmail.com",
        age: 16
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
