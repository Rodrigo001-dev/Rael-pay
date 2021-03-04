# esse vai ser um controller responsável por somente tratar erros
defmodule RaelPayWeb.FallbackController do
  use RaelPayWeb, :controller

  # se cair qualquer erro dentro do FallbackController
  def call(conn, {:error, result}) do
    # vai pegar a conexão
    conn
    # vai colocar um status de bad_request(400)
    |> put_status(:bad_request)
    # vai chamar a view de erros
    |> put_view(RaelPayWeb.ErrorView)
    # e vai chamar uma função render
    |> render("400.json", result: result)
  end
end
