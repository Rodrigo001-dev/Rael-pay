defmodule RaelPay.Numbers do
  def sum_from_file(filename) do
    # #{} fazendo interpolação
    # o igual(=) no elixir não é algo para atribuir um valor o igual(=) é um
    # operador de Match
    # ex: quando eu faço x = 1 eu não estou atribuindo um valor, isso é uma
    # operação matemática, quando acontece x = 1 eu tenho que pensar o seguinte
    # qual valor o x tem que assumir para que essa expreção seja verdade, ou
    # seja, o x tem que assummir o valor de 1

    # para que essa expreção seja verdade({:ok, file} = File.read("#{filename}.csv"))
    # o quanto que file tem que valer? => tem que valer o próprio conteúdo do
    # arquivo
    # {:ok, file} = File.read("#{filename}.csv")
    # file = File.read("#{filename}.csv")
    # handle_file(file)
    # aqui eu estou utilizando o pipe operator(|>)
    # o pipe operator pega o retorno da operação anterior e passa como primeiro
    # argumento para a função seguinte, ou seja, ele está pegando a
    # string("#{filename}.csv") passando como primeiro argumento da função
    # File.read() e o retorno da função File.read() está sendo passado para a
    # funão handle_file() sempre como primeiro argumento
    "#{filename}.csv"
    |> File.read()
    |> handle_file()
  end

  # quando eu crio uma função com o p no final(defp) quer dizer que é uma função
  # privada, ou seja, eu não quero que ninguém chame ela, ela é apenas para
  # controle interno
  # aqui eu estou falando que caso a minha função receba um :ok e um
  # conteúdo(file) eu vou retornar esse conteúdo
  defp handle_file({:ok, result}) do
    # separando as Strings("1,2,3,4,8,9,10") em uma lista(
    # ["1", "2", "3", "4", "8", "9", "10"]) separado por virgulas
    # result = String.split(result, ",")
    # o fn é o argumento que essa função recebe
    # convertendo as Strings da lista para números
    # result = Enum.map(result, fn number -> String.to_integer(number) end)
    # fazendo a suma dos números da lista que foram convertidos
    # result = Enum.sum(result)
    # sempre a ultima linha é o que é retornado em uma função
    # result
    # eu tive que repetir o result várias vezes porque eu estou em uma linguagem
    # imutável, o result não é alterado quando eu passo ele para os modulos

    # agora vou fazer utilizando o pipe operator
    result =
      result
      |> String.split(",")
      # |> Enum.map(fn number -> String.to_integer(number) end)
      # o Stream faz a mesma coisa do modulo Enum só que o Stream é um operador
      # lazy que é um operador preguiçoso, ele só executa quando precisamos do
      # resultado
      |> Stream.map(fn number -> String.to_integer(number) end)
      # quando eu for somar o Stream vai ser experto para converter para inteiro
      # e somar em uma unica execução deferente do Enum.map
      |> Enum.sum()
    # estou devolvendo um ok e o result com chave e valor(%{result: result})
    {:ok, %{result: result}}
  end
  # e caso eu receba um erro e um motivo qualquer(_reason) mesmo sendo por
  # qualquer motivo eu tenho que colocar o _reason porque tem que ser uma tupla
  # de 2 elementos eu vou devolver uma menssagem(Invalid)
  defp handle_file({:error, _reason}), do: {:error, %{message: "Invalid file!"}}
end
