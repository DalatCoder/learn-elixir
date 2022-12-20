defmodule Identicon do
  def main(input) do
    input
    |> has_input()
  end

  def has_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list()
  end
end
