# Miki

Miki，[PKU 直聘](https://github.com/chyyy510/SE_Project)的下一代后端。

## 配置开发环境

1. 安装 [Erlang/OTP](https://www.erlang.org/) 27；
2. 安装 [Elixir](https://elixir-lang.org/) 1.17；

   对于 Windows，安装以上两者是简单的。对于 Linux（仅在 Ubuntu 24.04 测试），请依 [Install Elixir](https://elixir-lang.org/install.html#install-scripts) 操作。
3. 克隆本仓库；
4. 运行 `mix deps.get` 获取依赖库；
5. 注意 `config` 目录。在其中新建 `config.exs` 文件，填写服务器配置。

   配置示例：

   ```elixir
   import Config

   config :miki, ecto_repos: [Miki.Repo]

   config :miki, Miki.Repo,
     database: "backend_1",
     username: "user_1",
     password: "123456",
     hostname: "127.0.0.1",
     port: 47357

   config :miki,
     port: 8000
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
