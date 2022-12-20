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
