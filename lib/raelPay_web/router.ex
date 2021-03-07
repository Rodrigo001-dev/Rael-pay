defmodule RaelPayWeb.Router do
  use RaelPayWeb, :router

  import Plug.BasicAuth

  # o pipeline é como se fosse as regras que as rotas tem que seguir
  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    # o Application.compile_env!() em tempo de compilação ele vai ler a
    # configuração que eu passei para ele
    # o plug é uma convenção de composição de modulos para manipular a conexão
    # o plug permite criar modulos que recebam a conexão e a modifique
    plug :basic_auth, Application.compile_env(:raelPay, :basic_auth)
  end

  scope "/api", RaelPayWeb do
    # quando eu coloco esse pipe_through quer dizer que todas as rotas dentro
    # desse escopo deve seguir as regras do pipeline api
    pipe_through :api

    # dentro do escopo api esta sendo criado uma rota do tipo Get para o
    # endereço / e o WelcomeController vai receber essa requisição na action
    # chamada index
    # esse :filename quer dizer que pela URL vai receber o nome do arquivo que
    # vai ser lido e vai ter a soma
    get "/:filename", WelcomeController, :index

    post "/users", UsersController, :create
  end

  scope "/api", RaelPayWeb do
    pipe_through [:api, :auth]

    post "/accounts/:id/deposit", AccountsController, :deposit
    post "/accounts/:id/withdraw", AccountsController, :withdraw
    post "/accounts/transaction", AccountsController, :transaction
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: RaelPayWeb.Telemetry
    end
  end
end
