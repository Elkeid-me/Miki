defmodule Miki.Users do
  use Ecto.Schema
  import Ecto.Query
  import Miki.Utils

  schema "users" do
    field(:username, :string)
    field(:nickname, :string)
    field(:email, :string)
    field(:password, :string)
    field(:register_time, :utc_datetime)
  end

  def get_user_by_id(id),
    do: Miki.Users |> where(id: ^id) |> Miki.Repo.all() |> unique()

  def get_user_by_name(username),
    do: Miki.Users |> where(username: ^username) |> Miki.Repo.all() |> unique()

  def get_user_by_email(email),
    do: Miki.Users |> where(email: ^email) |> Miki.Repo.all() |> unique()

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
        register_time: current_time()
      }
      |> Miki.Repo.insert()
end
