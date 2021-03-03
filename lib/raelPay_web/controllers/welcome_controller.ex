#  estou criando um modulo no context atual, um module nada mais é do que um
# agrupamento de funções
defmodule RaelPayWeb.WelcomeController do
  # esse modulo é um modulo especial(é um controller) e por isso que coloco essa
  # linha
  use RaelPayWeb, :controller

  alias RaelPay.Numbers

  # toda função em um controller recebe 2 parâmetros a conexão(conn) e os
  # parâmetros que está recebendo na requisição(params) e como eu não estou
  # recebendo nada pela URL eu coloco _params para ignorar os parâmetros
  # def index(conn, _params) do
  # estou pegando o filename("filename") e salvando o valor dentro de uma
  # variável( => filename)
  def index(conn, %{"filename" => filename}) do
    # estou devolvendo um texto, mas sempre tem que devolver a conexão
    # text(conn, "Welcome to the RaelPay API")
    filename
    |> Numbers.sum_from_file()
    |> handle_response(conn)
  end

  # se eu receber um ok e um resultado
  defp handle_response({:ok, %{result: result}}, conn) do
    # na minha conexão
    conn
      # eu vou colocar um status ok(200)
      |> put_status(:ok)
      # e vou devolver uma resposta em JSON que vai ser uma menssagem que vai
      # ter o rsultado
      |> json(%{message: "Welcome to RaelPay API. Here is your number #{result}"})
  end

  # caso eu receba um erro por qualquer motivo
  defp handle_response({:error, reason}, conn) do
    # na minha conexão
    conn
      # eu vou colocar um status bad_request(400)
      |> put_status(:bad_request)
      # e retornar o motivo que deu erro em JSON
      |> json(reason)
  end
end
