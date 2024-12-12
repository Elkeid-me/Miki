# Miki

Miki，[PKU 直聘](https://github.com/chyyy510/SE_Project)的下一代后端。网络部分使用 Plug 库，数据库部分使用 Ecto 库。

## 配置开发环境

1. 安装 [Erlang/OTP](https://www.erlang.org/) 27；
2. 安装 [Elixir](https://elixir-lang.org/) 1.17；

   对于 Windows，安装以上两者是简单的。对于 Linux（仅在 Ubuntu 24.04 测试），请依 [Install Elixir](https://elixir-lang.org/install.html#install-scripts) 操作。
3. 克隆本仓库；
4. 运行 `mix deps.get` 获取依赖库；
5. 假定你已经配置好了 MySQL。
6. 注意 `config` 目录。在其中新建 `config.exs` 文件，填写服务器配置。

   配置示例：

   ```elixir
   import Config

   config :miki, ecto_repos: [Miki.Repo]

   config :miki, Miki.Repo,
     database: "backend",
     username: "user",
     password: "123456",
     hostname: "127.0.0.1",
     port: 3306

   config :miki,
     port: 8000
   ```
7. 数据库 migration。
   ```bash
   mix ecto.migrate
   ```

## Debug 运行

```bash
mix run --no-halt
```

## Release 编译

1. 临时设定 `MIX_ENV` 环境变量为 `prod`。
   - PowerShell：
     ```pwsh
     $env:MIX_ENV="prod"
     ```
   - Zsh/Bash
     ```bash
     export MIX_ENV=prod
     ```
2. 编译
   ```bash
   mix release
   ```

## Release 运行

```bash
./_build/prod/rel/miki/bin/miki start
```
## 数据传输标准

**由于 Elixir `Map` 的特性，以下 JSON 的字段*顺序*可能与生产环境不同**

### 用户登录

- API：`<host>:<port>/users/login`（例如 `127.0.0.1:8080/users/login`）
- 方法：POST
  - header
    - `content-type`: `application/json`
  - body
    ```json
    {
      "email": "alice@gmail.com",
      "password": "114514"
    }
    ```
- 返回
  - header
    - status: `200`
    - `content-type`: `application/json`
  - body

    登录成功：
    ```json
    {
      "message": "Successfully logged in.",
      "id": 1,
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzI5NzQ3NTc2LCJpYXQiOjE3Mjk3NDcyNzYsImp0aSI6ImJhMWRhOTMyMWJmYjQyOWVhZTJiNDBmOGFhOTdhZDY2IiwidXNlcl9pZCI6MX0.YKAtBt7fAzr8Q8cenyrJfrCAuMWb41co22okeZ1zuoo"
    }
    ```
    登录失败（电子邮件不存在，或密码错误）：
    ```json
    { "message": "Invalid email or password." }
    ```
    不合法的参数（例如没有 `password`）：
    ```json
    { "message": "Invalid parameters." }
    ```
### 用户注册

- API：`<host>:<port>/users/register`
- 方法：POST
  - header
    - `content-type`: `application/json`
  - body
    ```json
    {
      "username": "alice",
      "nickname": "OTTO",
      "email": "alice@gmail.com",
      "password": "114514"
    }
    ```
- 返回
  - header
    - status：`200`
    - `content-type`: `application/json`
  - body

    注册成功：
    ```json
    {
      "message": "Successfully registered.",
      "token": ""
    }
    ```
    注册失败：
    ```json
    { "message": "Email already exists." }
    ```
    或
    ```json
    { "message": "Username already exists." }
    ```
    未知原因的注册错误：
    ```json
    { "message": "Failed to register." }
    ```
    不合法的参数（例如没有 `password`）：
    ```json
    { "message": "Invalid parameters." }
    ```

### 更新 token

### 当前用户主页信息

- API：`<host>:<port>/users/profile`
- 方法：GET
  - header
    - `token`：`<token>`
- 返回
  - header
    - status：`200`
    - `content-type`: `application/json`
  - body
    ```json
    {
      "username": "alice",
      "email": "alice@gmail.com",
      "nickname": "Alice",
      "id": 46531
    }
    ```

### 某个用户主页信息

- API：`<host>:<port>/users/profile/<用户 id>`
- 方法：GET
- 返回
  - header
    - status：`200`
    - `content-type`: `application/json`
  - body

    如果用户存在：
    ```json
    {
      "username": "alice",
      "email": "alice@gmail.com",
      "nickname": "Alice",
      "id": 46531
    }
    ```
    用户不存在：
    ```json
    { }
    ```

### 所有实验信息：

- API：`<host>:<port>/experiments`
- 方法：GET
- 返回
  - header
    - status：`200`
    - `content-type`: `application/json`
  - body
    ```json
    {
      "count": 4,
      "results": [
        {
          "active": true,
          "creator_id": 1,
          "description": "?",
          "id": 1,
          "money_left": "0", // decimal……
          "money_paid": "0",
          "money_per_person": "114514",
          "person_already": 0,
          "person_wanted": 1,
          "time_created": "2024-12-12T12:03:52Z", // UTC 时间，即零时区。
          "time_modified": "2024-12-12T12:03:52Z",
          "title": "哇袄"
        },
        {
          "active": true,
          "creator_id": 2,
          "description": "?",
          "id": 2,
          "money_left": "0",
          "money_paid": "0",
          "money_per_person": "114514",
          "person_already": 0,
          "person_wanted": 1,
          "time_created": "2024-12-12T12:05:31Z",
          "time_modified": "2024-12-12T12:05:31Z",
          "title": "哇袄"
        }
      ]
    }
    ```

### 创建实验

- API：`<host>:<port>/experiments/create`
- 方法：POST
  - header
    - `content-type`: `application/json`
    - `token`：`<token>`
  - body
    ```json
    {
      "title": "哇袄",
      "description": "?",
      "person_wanted": 20,
      "money_per_person": 10
    }
    ```
- 返回
  - header
    - status：`200`
    - `content-type`: `application/json`
  - body

  创建成功：
    ```json
    {
      "active": true,
      "creator_id": 2,
      "description": "?",
      "id": 2,
      "money_left": "0",
      "money_paid": "0",
      "money_per_person": "114514",
      "person_already": 0,
      "person_wanted": 1,
      "time_created": "2024-12-12T12:05:31Z", // UTC 时间，即零时区。
      "time_modified": "2024-12-12T12:05:31Z",
      "title": "哇袄"
    }
    ```
    未知原因的创建错误：
    ```json
    { "message": "Failed to create experiment." }
    ```
    不合法的参数（例如没有 `description`）：
    ```json
    { "message": "Invalid parameters." }

### 编辑实验

- API：`<host>:<port>/experiments/edit`
- 方法：POST
  - header
    - `content-type`: `application/json`
    - `token`：`<token>`
  - body
    ```json
    {
      "active": true, // 或者 false，如果想暂停实验
      "title": "哇袄",
      "description": "?",
      "person_wanted": 20,
      "money_per_person": 10
    }
    ```
  - 注意：以上五个字段不必同时存在。如果只想更新 `title`，则可以
    ```json
    { "title": "哇袄" }
    ```

### 参加实验

- API：`<host>:<port>/experiments/participate/<实验 id>`
- 方法：GET
  - header
    - `token`：`<token>`

### 搜索实验
