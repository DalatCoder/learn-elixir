# Identicon

We're going to write a module that will generate an identical image.
The random image that `github` uses when we're not uploading
any avatar when creating new account. Something that is some
number of pixels across some number of pixels down and has some
color design.

An identical twin is formed of a `5x5` grid (`250px x 250px`).

Requirements:

- Each identical line should not be randomly generated. If I
  enter the same string twice, I should always get back the
  same identical

Flow of our app

- Input string
- Fetch into Identicon Generator
- Get output image

Detail flow

- Input string
- Compute MD5 hash of string
- List of numbers based on the string
- Pick color
- Build grid of squares
- Convert grid into image
- Save image

## Hashing a String

```elixir
hash = :crypto.hash(:md5, "banana")
```

Using `:crypto.hash(:md5, "banana")`, this will give us
back a series of `bytes` that represents the hash string `banana`

To turn the returned `bytes` into readable stream, we can use
`Base.encode16`

```elixir
hash = :crypto.hash(:md5, "banana")
Base.encode16(hash)
```

To get list of binary number

```elixir
hash = :crypto.hash(:md5, "banana")
:binary.bin_to_list(hash)
```

And the `hash_input` function

```elixir
def has_input(input) do
  :crypto.hash(:md5, input)
  |> :binary.bin_to_list()
end
```

The number in the list range from `0` to `255`. So if we just take
the first three numberes on this list and we use those as RGB or
`red`, `green`, `blue`

In summary, we turn our input into a list of numbers. We use
the first three numbers in there to generate the color of our
identical line. We assign each of these numbers onto our grid
and then if a given cell is even, we will show the color.

## Structs - Elixir's Data Modeling Tool

### Modeling data with Structs

A struct is just like `map`, they just have two advantages over maps:

- they can be assigned default values
- they have some additional compile time checking of properties

To define a struct, we need to make a new module

```elixir
defmodule Identicon.Image do
  defstruct hex: nil
end
```

Define a struct called `Identicon.Image` that has 1 property
called `hex` and the default value is `nil`

To create new struct

```elixir
%Identicon.Image{}
%Identicon.Image{hex: []}
```

We change the `hash_input` function to return the struct

```elixir
def hash_input(input) do
  hex =
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list()

  %Identicon.Image{hex: hex}
end
```

The struct only contains properties, not methods. The struct is
just a map under the hood and has absolutely no ability to
attach any functions to it. It can only hold some primitive data.

### Pattern Matching Structs

The `pick_color` purpose is going to be pull of the first three
values of our `hex` list, which are going to serve as the `RGB`
color for our identical.

```elixir
def pick_color(image) do
  %Identicon.Image{hex: hex_list} = image
  [red, green, blue | _tail] = hex_list

  [red, green, blue]
end
```

The code above means: give me the first three values, `RGB` and
I don't care about the rest.

Shorter

```elixir
def pick_color(image) do
  %Identicon.Image{hex: [red, green, blue | _tail]} = image
  [red, green, blue]
end
```

### Updating structs

Add new prop to the struct`

```elixir
defmodule Identicon.Image do
  defstruct hex: nil, color: nil
end
```

To update struct, we create new struct with all existing properties
and then update any props we need

```elixir
def pick_color(image) do
  %Identicon.Image{hex: hex_list} = image
  [red, green, blue | _tail] = hex_list
  %Identicon.Image{image | color: {red, green, blue}}
end
```

Elixir supports pattern matching in argument list

```elixir
def pick_color(%Identicon.Image{hex: [red, green, blue | _tail]} = image) do
  %Identicon.Image{image | color: {red, green, blue}}
end
```

### Building the grid

Flow

- Hex list contains 16 numbers
- `Enum.chunk(3)` to chunk the original lists into some
  chunks, each chunk is a list and contain 3 numbers
- Then, we mirror each rows to make the complete row

```elixir
def build_grid(image) do
  %Identicon.Image{hex: hex} = image

  hex
  |> Enum.chunk(3)
end
```

### Mirroring a Row

Currently we have a list of chunks like this

```elixir
Identicon.main("hieu")

# [[150, 136, 85], [19, 45, 197], [208, 235, 46], [215, 192, 252], [78, 243, 66]]
```

We need to mirror each chunk like this

```elixir
# [[150, 136, 85, 136, 150]]
```

The help function looks like this

```elixir
def mirror_row(row) do
  # [145, 46, 200]
  [first, second | _tail] = row

  # [145, 46, 200, 46, 145]
  row ++ [second, first]
end
```

We use `++` operator to join two lists together.

### Mapping with custom functions

We could use the `Enum.map` function to transform our chunk
into mirrow list item.

```elixir
def build_grid(image) do
  %Identicon.Image{hex: hex} = image

  hex
  |> Enum.chunk(3)
  |> Enum.map(mirror_row)
end
```

However, if we just pass the function like this, by default,
Elixir will going to invoke it.

To pass a `reference` to a function in `elixir`, we use a
little bit different syntax.

```elixir
def build_grid(image) do
  %Identicon.Image{hex: hex} = image

  hex
  |> Enum.chunk(3)
  |> Enum.map(&mirror_row/1)
end
```

The code above means we pass the `ref` of `mirror_row` function
into the `map` function. The `mirrow_row` function accepts 1
args.
