defmodule Identicon do
  def main(input) do
    input
    |> hash_input()
    |> pick_color()
  end

  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end

  def pick_color(image) do
    %Identicon.Image{hex: hex_list} = image
    [red, green, blue | _tail] = hex_list

    [red, green, blue]
  end
end
