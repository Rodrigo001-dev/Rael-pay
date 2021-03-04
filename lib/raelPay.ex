defmodule RaelPay do
  alias RaelPay.Users.Create, as: UserCreate

  # aqui eu estou criando uma fachada, ou seja, todo o usuário da minha
  # aplicação vai conhecer só esse modulo (RaelPay)
  # esse as: quer dizer que eu estou chamando a função call
  defdelegate create_user(params), to: UserCreate, as: :call
end
