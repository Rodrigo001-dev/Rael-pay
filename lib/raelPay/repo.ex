defmodule RaelPay.Repo do
  use Ecto.Repo,
    otp_app: :raelPay,
    adapter: Ecto.Adapters.Postgres
end
