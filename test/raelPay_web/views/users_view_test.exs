defmodule RaelPayWeb.UsersViewTest do
  use RaelPayWeb.ConnCase, async: true

  import Phoenix.View

  alias RaelPay.{Account, User}
  alias RaelPayWeb.UsersView

  test "renders create.json" do
    params = %{
      name: "Rodrigo",
      password: "123456",
      nickname: "RaelRodrigo001",
      email: "rodrigorael53@gmail.com",
      age: 18
    }

    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} =
      RaelPay.create_user(params)

    response = render(UsersView, "create.json", user: user)

    expected_response = %{
      message: "User created",
      user: %{
        account: %{
          balance: Decimal.new("0.00"),
          id: account_id
        },
        id: user_id,
        name: "Rodrigo",
        nickname: "RaelRodrigo001"
      }
    }

    assert expected_response = response
  end
end
