defmodule Miki.Users do
  use Ecto.Schema
  import Ecto.Query
  alias(Miki.{Experiments, Participations, Repo, Users, Utils})

  schema "users" do
    field(:username, :string)
    field(:nickname, :string)
    field(:email, :string)
    field(:password, :string)
    field(:token, :string)
    field(:register_time, :utc_datetime)
    has_many(:experiments_created, Experiments, foreign_key: :creator_id)

    many_to_many(:experiments_participate_in, Experiments,
      join_through: Participations,
      join_keys: [user_id: :id, experiment_id: :id]
    )
  end

  @doc """
  用 `id` 获取用户的基础信息。即用户名、邮箱、昵称。用户不存在时返回 `nil`
  """
  def instruction(id),
    do: Users |> where(id: ^id) |> select([:id, :username, :email, :nickname]) |> Repo.one()

  @doc """
  类似 `Experiments.to_map/1`
  """
  def to_map(user), do: user |> Map.take([:id, :username, :email, :nickname])

  @doc """
  用 `id` 获取用户的更详细信息。除 `instruction` 外，还有注册时间、参与的实验、创建的实验。直接返回 %Miki.User{}。用户不存在时返回 `nil`
  """
  def profile(id),
    do:
      Users
      |> where(id: ^id)
      |> select([:id, :username, :email, :nickname, :register_time])
      |> Repo.one()
      |> Repo.preload([:experiments_created, :experiments_participate_in])

  @doc """
  用 `token` 获取 `id`。用户不存在时返回 `nil`。
  """
  def get_id_by_token(token) do
    case Users |> where(token: ^token) |> select([:id]) |> Repo.one() do
      nil -> nil
      user -> user.id
    end
  end

  @doc """
  登录时候专用的函数，用 email 查询 id、password 和 token。用户不存在时返回 nil
  """
  def get_id_password_token_by_email(email),
    do: Users |> where(email: ^email) |> select([:id, :password, :token]) |> Repo.one()

  def username_exists?(username),
    do: Users |> where(username: ^username) |> Repo.exists?()

  def email_exists?(email), do: Users |> where(email: ^email) |> Repo.exists?()

  def id_exists?(id), do: Users |> where(id: ^id) |> Repo.exists?()

  def new(username, nickname, email, password) do
    token = username <> (:crypto.strong_rand_bytes(128) |> Base.encode64())

    %Users{
      username: username,
      nickname: nickname,
      email: email,
      password: password,
      token: token,
      register_time: Utils.current_time()
    }
    |> Repo.insert()
  end
end
