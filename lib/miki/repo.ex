defmodule Miki.Repo do
  use Ecto.Repo,
    otp_app: :miki,
    adapter: Ecto.Adapters.MyXQL
end
