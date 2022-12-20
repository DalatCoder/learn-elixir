defmodule Identicon do
  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> filter_odd_squares()
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
    %Identicon.Image{image | color: {red, green, blue}}
  end

  def build_grid(image) do
    %Identicon.Image{hex: hex} = image

    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    # [145, 46, 200]
    [first, second | _tail] = row

    # [145, 46, 200, 46, 145]
    row ++ [second, first]
  end

  def filter_odd_squares(image) do
    %Identicon.Image{grid: grid} = image

    even_grid =
      Enum.filter(grid, fn square ->
        {code, _index} = square
        rem(code, 2) == 0
      end)

    %Identicon.Image{image | grid: even_grid}
  end
end
