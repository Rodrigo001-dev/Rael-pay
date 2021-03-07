defmodule RaelPayWeb.AccountsControllerTest do
  # estu utilizando o ConnCase porque aqui nesse arquivo vai ter funcionalidades
  # de controllers que vai ter que chamar no teste
  use RaelPayWeb.ConnCase, async: true

  alias RaelPay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Rodrigo",
        password: "123456",
        nickname: "RaelRodrigo001",
        email: "rodrigorael53@gmail.com",
        age: 18
      }

      {:ok, %User{account: %Account{id: account_id}}} = RaelPay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")

      # no final do bloco de setup que é algo que tem que ser feito antes dos
      # testes, vai ter uma tupla que vai devolver obrigatóriamente ok e como é
      # teste de controller eu tenho que passar a conexão e também qualque outro
      # parâmetro que eu queira passar para o meu teste
      {:ok, conn: conn, account_id: account_id}
    end

    # essa , e o pattern match(%{}) é para ler os dados que eu criei no setup
    test "when all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
        conn
        # para acessar a rota desse arquivo eu tenho o Routes do ConnCase.
        # o accounts_path é para ler todos os paths da account, como primeiro
        # parâmetro tem que passar a conexão, no segundo parâmetro tem que passar
        # a rota/action que eu quero chamar(deposit), no terceiro parâmetro é o
        # parâmetro que eu quero enviar via URL(account_id) e o quarto argumento
        # é os parâmetros
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)
      assert %{
        "account" => %{"balance" => "50.00", "id" => _id},
        "message" => "Ballance changed successfully"
      } = response
    end

    test "when there ara invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "rael"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid deposit value!"}

      assert response == expected_response
    end
  end
end
