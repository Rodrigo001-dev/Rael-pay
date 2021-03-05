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

  # o changeset vai receber 2 parâmetros, porque tem como trabalhar com o
  # changeset de duas formas.
  # um changeset de criação que sempre é o parto de uma struct
  # vazia(%__MODULE__{}).
  # ou um changeset de update, o changeset de update não começa com uma struct
  # vazia(%__MODULE__{}), ele começa com uma struct já preenchida, que eu estou
  # passando como argumento(struct \\ %__MODULE__{}) e assim o cast só vai fazer
  # cast da quilo que muda quando eu passo uma struct que não é vazia, uma
  # struct que já tem dados lá.
  # o \\ quer dizer que é um argumento defualt, ou seja, se eu não passar uma
  # struct de update ele vai passar uma struct de criação
  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    # vai verificar se esta atendendo a constraint de que o saldo(balance) não
    # pode ser negativo
    |> check_constraint(:balance, name: :balance_must_be_positive_or_zero)
  end
end
