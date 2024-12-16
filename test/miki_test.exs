defmodule MikiTest do
  use ExUnit.Case
  use Plug.Test
  # doctest Miki

  defp send_test_resp(method, path), do: conn(method, path) |> Miki.Router.call([])

  test "not 500" do
    assert(send_test_resp(:get, "/").status == 404)

    assert(send_test_resp(:post, "/users/register").status != 500)
    assert(send_test_resp(:post, "/users/login").status != 500)

    assert(send_test_resp(:get, "/users/profile").status != 500)
    assert(send_test_resp(:get, "/users/profile/1").status != 500)
    assert(send_test_resp(:get, "/users/profile/114514").status != 500)
    assert(send_test_resp(:get, "/users/instruction").status != 500)
    assert(send_test_resp(:get, "/users/instruction/1").status != 500)
    assert(send_test_resp(:get, "/users/instruction/114514").status != 500)

    assert(send_test_resp(:get, "/experiments").status != 500)
    assert(send_test_resp(:get, "/experiments/1").status != 500)
    assert(send_test_resp(:get, "/experiments/114514").status != 500)
  end
end
