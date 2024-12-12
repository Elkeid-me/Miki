defmodule Miki.Utils.UniqueQuery do
  def unique(items) do
    case items do
      [item] -> item
      _ -> nil
    end
  end
end
