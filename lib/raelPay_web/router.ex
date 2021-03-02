defmodule RaelPayWeb.Router do
  use RaelPayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RaelPayWeb do
    pipe_through :api

    # dentro do escopo api esta sendo criado uma rota do tipo Get para o
    # endereço / e o WelcomeController vai receber essa requisição na action
    # chamada index
    get "/", WelcomeController, :index
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
