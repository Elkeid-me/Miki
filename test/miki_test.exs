defmodule MikiTest do
  use ExUnit.Case
  doctest Miki

  test "greets the world" do
    assert Miki.hello() == :world
  end
end
