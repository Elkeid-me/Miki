defmodule Miki.Users do
  use Ecto.Schema
  import Ecto.Query

  schema "users" do
    field(:username, :string)
    field(:nickname, :string)
    field(:email, :string)
    field(:password, :string)
  end

  def get_user_by_name(username) do
    Miki.Users |> where(username: ^username) |> Miki.Repo.all()
  end

  def get_user_by_email(email) do
    Miki.Users |> where(email: ^email) |> Miki.Repo.all()
  end

  def add_user(username, nickname, email, password) do
    %Miki.Users{username: username, nickname: nickname, email: email, password: password}
    |> Miki.Repo.insert()
  end
end
