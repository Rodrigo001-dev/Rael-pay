defmodule RaelPay.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias RaelPay.User

  @primary_key {:id, :binary_id, autogenerate: true}
  # falando que a chave estrangeira é do tipo binary_id
  @foreign_key_type :binary_id

  @required_params [:balance, :user_id]

  schema "accounts" do
    field :balance, :decimal
    # estou querendo dizer que essa tabela pertence ao usuário
    belongs_to :user, User

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    # vai verificar se esta atendendo a constraint de que o saldo(balance) não
    # pode ser negativo
    |> check_constraint(:balance, name: :balance_must_be_positive_or_zero)
  end
end
