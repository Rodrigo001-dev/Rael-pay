defmodule RaelPayWeb.UsersController do
  use RaelPayWeb, :controller

  alias RaelPay.User

  # falando que existe um controller de fallback
  action_fallback RaelPayWeb.FallbackController

  def create(conn, params) do
    # o with verifica um caso, se esse caso funcionar eu executo o corpo da
    # função mas sempre que o with falha ele devolve o erro para quem chamou(
    # quem vai receber o erro vai ser o FallbackController)
    with {:ok, %User{} = user} <- RaelPay.create_user(params) do
      # se eu receber um ok e um %User{} eu vou pegar a minha conexão e colocar um
      # status de created(201)
      conn
      |> put_status(:created)
      # estou renderizando a view
      |> render("create.json", user: user)
    end
  end
end
