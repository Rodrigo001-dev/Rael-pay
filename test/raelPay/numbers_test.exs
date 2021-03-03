# todo os teste vai ser o mesmo nome de modulo só que com um test no final
defmodule RaelPay.NumbersTest do
  # todo teste tem que ter um use ExUnit.Case para falar que é um arquivo de
  # teste
  use ExUnit.Case

  # alias é apenas um apelido
  alias RaelPay.Numbers

  # para testar sempre coloca um describe ai depois o nome da função que vai ser
  # testada e depois do / é quantos argumentos ela espera
  describe "sum_from_file/1" do
    test "when there is a file with the given name, returns the sum of numbers" do
      response = Numbers.sum_from_file("numbers")

      expected_response = {:ok, %{result: 37}}

      # o assert vai verificar o teste
      assert response == expected_response
    end

    test "when there is no file with the given name, returns an error" do
      response = Numbers.sum_from_file("banana")

      expected_response = {:error, %{message: "Invalid file!"}}

      assert response == expected_response
    end
  end
end
