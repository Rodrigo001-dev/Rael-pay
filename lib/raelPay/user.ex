# vai ser criado o schema, ele é o cara que vai mapear o dado para a minha
# tabela
defmodule RaelPay.User do
  # estou falando que vai ser uma schema
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset

  # @primary_key é uma variável de modulo, como se fosse uma variável constante
  # só que os schemas tem uma variável de modulo especial que é o primary_key
  # que eu defino qual o formato da chave primaria no banco de dados
  # :binary id que dizer qua vai ser utilizado uuid
  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:name, :age, :email, :password, :nickname]

  # para definir uma schema sempre utiliza schema "nome da tabela"
  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
    # quando eu coloco que ele é virtual que dizer que ele só existe no schema
    # e no banco de dados não
    field :password, :string, virtual: true
    field :password_hash, :string
    field :nickname, :string

    timestamps()
  end

  # o changeset é uma estrutura responsável por inserir os dados dentro do
  # schema da tabela do banco de dados fazendo mapeamentos e validações
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    # falando que todos os parâmetros são required(obrigatórios)
    |> validate_required(@required_params)
    |> validate_length(:password, min: 6)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint([:email])
    |> unique_constraint([:nickname])
    |> put_password_hash()
  end

  # dado que o Changeset é valido e eu estou lendo o password lá, eu vou
  # encriptar o password
  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    # a função change recebe um Changeset e modifica ele
    # esse changeset que está sendo passado como primeiro parâmetro eu já atribui
    # um valor para ela dentro da função put_password_hash
    # e o segundo parâmetro vai encriptar o password
    change(changeset, Bcrypt.add_hash(password))
  end

  # se o changeset não for valido eu vou devolver ele
  defp put_password_hash(changeset), do: changeset
end
