#  estou criando um modulo no context atual, um module nada mais é do que um
# agrupamento de funções
defmodule RaelPayWeb.WelcomeController do
  # esse modulo é um modulo especial(é um controller) e por isso que coloco essa
  # linha
  use RaelPayWeb, :controller

  # toda função em um controller recebe 2 parâmetros a conexão(conn) e os
  # parâmetros que está recebendo na requisição(params) e como eu não estou
  # recebendo nada pela URL eu coloco _params para ignorar os parâmetros
  def index(conn, _params) do
    # estou devolvendo um texto, mas sempre tem que devolver a conexão
    text(conn, "Welcome to the RaelPay API")
  end
end
