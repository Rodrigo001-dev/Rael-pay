defmodule RaelPayWeb.UsersController do
  use RaelPayWeb, :controller

  alias RaelPay.User

  def create(conn, params) do
    params
    |> RaelPay.create_user()
    |> handle_response(conn)
  end

  defp handle_response({:ok, %User{} = user}, conn) do
    # se eu receber um ok e um %User{} eu vou pegar a minha conexão e colocar um
    # status de created(201)
    conn
    |> put_status(:created)
    # estou renderizando a view
    |> render("create.json", user: user)
  end

  defp handle_response({:error, result}, conn) do
    conn
    |> put_status(:bad_request)
    |> put_view(RaelPayWeb.ErrorView)
    |> render("400.json", result: result)
  end
end
