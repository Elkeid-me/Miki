defmodule Miki.Users.Profile do
  import Plug.Conn
  import Miki.Users
  import Miki.Utils

  def init(options), do: options

  defp send_profile(conn, %{
         experiments_created: exp_c,
         experiments_participate_in: exp_p,
         id: id,
         username: username,
         email: email,
         nickname: nickname,
         register_time: register_time
       }),
       do:
         conn
         |> send_json(%{
           "experiments_created" => exp_c |> Enum.map(fn exp -> Miki.Experiments.process_experiment(exp) end),
           "experiments_participate_in" => exp_p |> Enum.map(fn exp -> Miki.Experiments.process_experiment(exp) end),
           "username" => username,
           "email" => email,
           "nickname" => nickname,
           "register_time" => register_time,
           "id" => id
         })

  defp send_profile(conn, nil), do: conn |> send_json(%{})

  def(call(conn, _opts)) do
    case conn.params["id"] do
      nil ->
        with [token] <- get_req_header(conn, "token"),
             id when id != nil <- get_id_by_token(token) do
          user = profile(id)
          send_profile(conn, user)
        else
          _ -> conn |> send_json(%{})
        end

      id ->
        user = profile(id)
        send_profile(conn, user)
    end
  end
end
