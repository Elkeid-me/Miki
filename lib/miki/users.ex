defmodule Miki.Users do
  use Ecto.Schema
  import Ecto.Query
  import Miki.Utils

  schema "users" do
    field(:username, :string)
    field(:nickname, :string)
    field(:email, :string)
    field(:password, :string)
    field(:token, :string)
    field(:register_time, :utc_datetime)
  end

  def get_user_fields_by(by, value, fields),
    do: Miki.Users |> where(^[{by, value}]) |> select(^fields) |> Miki.Repo.all() |> unique()

  def username_exists?(username),
    do: Miki.Users |> where(username: ^username) |> Miki.Repo.aggregate(:count) > 0

  def email_exists?(email),
    do: Miki.Users |> where(email: ^email) |> Miki.Repo.aggregate(:count) > 0

  def add_user(username, nickname, email, password),
    do:
      %Miki.Users{
        username: username,
        nickname: nickname,
        email: email,
        password: password,
        token: username <> (:crypto.strong_rand_bytes(128) |> Base.encode64()),
        register_time: current_time()
      }
      |> Miki.Repo.insert()
end
