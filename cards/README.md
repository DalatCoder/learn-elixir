# Cards

## Generate new project

The first project using `elixir`

Using `mix` to create new `project`: `mix new cards`

Open `cards.ex` file in `lib` folder

```elixir
defmodule Cards do
end
```

`module`

- `defmodule`: defines module, create a module called `Cards`. Code in `elixir` is
  organizaed into different modules.

- A `module` is a collection of different `methods` or `functions`

Writing hello world function

```elixir
defmodule Cards do

  def hello do
    "hello world"
  end

end
```

- Define a function by using `def` keyword

To run the project: `iex -S mix`

- `iex`: interactive elixir shell
- using `-S` flag to compile our project and add some references to our project
- Typing `Cards.hello` to invoke our function, we don't have to put the `()` to
  invoke a function like `Cards.hello()`. However, we can put `()`, the result
  would be the same.
- Exlixir has an `implicit return`, so that the function `hello` return the string
  of `hello world`. Whenever a function runs, whatever the last value inside that
  function will automatically get returned.

```elixir
defmodule Cards do

  def hello do
    return "hello world"
  end

end
```

### Lists and Strings

- Using bracket `[]`
- String in written inside `""` (convention)
- `iex` does not automatically reload or recompile our code whenever something changes.
  We can type `recompile` inside the shell to recompile our project.

### OOP vs Functional Programming

Cards - OOP Approach

- Cards class

  - `this.suit string`
  - `this.value string`

- Deck class
  - `this.cards <[Card]>`
  - `this.shuffle <Function>`
  - `this.save <Function>`
  - `this.load <Function>`

### Method arguments

Implement shuffle function

```elixir
defmodule Cards do
  def create_deck do
    ["Ace", "Two", "Three"]
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end
end
```

Inside `IEx`

```sh
deck = Cards.create_deck

Cards.shuffle(deck)
Cards.shuffle(deck)
Cards.shuffle(deck)
```

### Immutability in Elixir

We never ever are modifying an existing data structure in place.

Immutability means that we don't change any of the existing data. Instead,
we create a copy of the data and then change whatever we want in some fashion.

### Searching a list

We will implement the function called `contains?` to check whether the
card exists in the deck.

The `?` is valid in function name in `elixir`. The convention is that if
a function has a question mark in it, it's probably going to return a `true`
or `false` boolean value.

```elixir
defmodule Cards do
  def create_deck do
    ["Ace", "Two", "Three"]
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end
end
```

### Comprehensions over lists

Get the deck of cards

#### option 1

We get an array

```elixir
def create_deck do
  values = ["Ace", "Two", "Three", "Four", "Five"]
  suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

  for value <- values do
    for suit <- suits do
      "#{value} of #{suit}"
    end
  end

end
```

#### option 2

Using `List.flatten` to flat an array into a list

```elixir
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    cards =
      for value <- values do
        for suit <- suits do
          "#{value} of #{suit}"
        end
      end

    List.flatten(cards)
  end
```

#### option 3

```elixir
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end
```

## Pattern Matching

```elixir
def deal(deck, hand_size) do
  Enum.split(deck, hand_size)
end

{ hand, rest_of_deck } = deal([], 5)
```

Pattern matching is used any time that we use the equals sign.

```elixir
colors = ["red"]

[color_red] = ["red"]

[color_red, color_blue] = ["red", "blue"]
```

### Elixir's relationship with Erlang

Elixir is not a standalone programming language.

- Code we write
- Gets fed into Elixir
- Transpiled into Erlang
- Compiled and executed by BEAM (like `JVM` in Java)

Elixir sits on top of Erlang, give us a better interface to Erlang.

Some functions are not fully transformed into elixir code, so we need
to use the `:erlang` to get it done.

```elixir
def save(deck, filename) do
  binary = :erlang.term_to_binary(deck)
  File.write(filename, binary)
end
```

### Check condition using case

```elixir
  def load(filename) do
    {status, binary} = File.read(filename)

    case status do
      :ok -> :erlang.binary_to_term(binary)
      :error -> "That file does not exist"
    end
  end
```

### Pattern matching in case statements

Whenever we see colon and then a word inside of elixir, this is a primitive data
type that we refer to as an `atom`

`Atom` are used throughout elixir as handling kind of like `status codes` or
`messages` or `handling control flow` throughout our application.

The most common `atom` that we're going to see while writing are `:ok` and `:error`

```elixir
  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, reason} -> reason
    end
  end
```

If we don't want to use the second variable, prefix it with `_`

```elixir
  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _reason} -> reason
    end
  end
```

### The `pipe` operator

Get the hand by calling some functions in order

```elixir
def create_hand(hand_size) do
  deck = Cards.create_deck()
  deck = Cards.shuffle(deck)
  hand = Cards.deal(deck, hand_size)
end
```

Using the `pipe` operator `|>`

```elixir
  def create_hand(hand_size) do
    Cards.create_deck()
    |> Cards.shuffle()
    |> Cards.deal(hand_size)
  end
```

The operator wants us to write methods that take consistent of
the `first` argument.

### Module documentation

The `mix.exs` file is like `package.json`

Install the `xdocs` package

- Open `mix.exs` file
- `deps`: `[ { :ex_doc, "~> 0.12"} ]`
- Run `mix deps.get` to install `:ex_doc` version `0.12`

## Testing and Documentation

### Documentation with `ex_doc`

Write documentations using `ex_doc`:

- Module documentations
- Function documentations

```elixir
defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """
end
```

```elixir
defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """

  @doc """
    Divides a deck into a hand and the remainder of the deck.
    The `hand_size` argument indicates how many cards should
    be in the hand.

    ## Examples

          iex> deck = Cards.create_deck
          iex> {hand, deck} = Cards.deal(deck, 1)
          iex> hand
          ["Ace of spades"]
  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end
end
```

- Generate docs using command: `mix docs`

### Introduction to testing

Testing in `exlixir` is a first class citizen. So in other words, teting is
incredibly fully featured out of the box without any real need to add
in additional libraries to write solid tests around our code.

Open `cards_test.exs` inside `test` folder.

In `elixir`, there are 2 types of tests that we can write

- Testing some singular and particular fact using `assertion` | (`case tests`)
- The secod type of testing is one of the most interesting and awesome methods of testing
  called `doc tests`

DocTests

- Write some function docs and an examples code
- Run `mix test`

### Writing effective `doctests`

Open `iex` shell, write some simple code and then copy all the code we have
written into our `function`

```elixir
defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """

  @doc """
    Returns a list of strings representing a deck of playing cards
  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
    Determines whether a deck contains a given card

    ## Examples
      iex> deck = Cards.create_deck()
      iex> Cards.contains?(deck, "Ace of Spades")
      true
  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
    Divides a deck into a hand and the remainder of the deck.
    The `hand_size` argument indicates how many cards should
    be in the hand.

    ## Examples

      iex> deck = Cards.create_deck
      iex> {hand, deck} = Cards.deal(deck, 1)
      iex> hand
      ["Ace of Spades"]
  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, reason} -> reason
    end
  end

  def create_hand(hand_size) do
    Cards.create_deck()
    |> Cards.shuffle()
    |> Cards.deal(hand_size)
  end
end

```

### Writing `case tests`

```elixir
defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "create_deck makes 20 cards" do
    deck_length = length(Cards.create_deck())
    assert deck_length == 20
  end
end
```

What do I test?

What behaviours do you really are about inside this module?

Maybe I really care that the deck that is created by `create_deck` has 20 cards
inside of it. That's a really important thing. Not only does it make sure that
I have the correct number of cards, but it also kind of implicitly implies that
`create_deck` is going to return a `list` to me as well.

```elixir
defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "create_deck makes 20 cards" do
    deck_length = length(Cards.create_deck())
    assert deck_length == 20
  end

  test "shuffling a deck randomizes it" do
    deck = Cards.create_deck()
    refute deck == Cards.shuffle(deck)

    # assert deck != Cards.shuffle(deck)
  end
end
```

Because `elixir` is functional programming style. With `FP`, we have learned
that we create some basic object representing our working data and then
we pass it off to functions and get some result back.

That means that when we test our code, we could create some basic object, passes
off to the function and then do some basic checks on the returned object.

## Other data structure

- maps
- keyword lists

### Maps

Maps are collections of key - value pairs.

```elixir
colors = %{primary: "red"}

colors.primary
```

Maps can hae multiple properties associated with them

```elixir
colors = %{primary: "red", secondary: "blue"}

colors.primary
colors.secondary
```

Map with pattern matching

```elixir
colors = %{primary: "red", secondary: "blue"}

%{ secondary: secondary_color } = colors
secondary_color
```

Updating values in a Map

```elixir
colors = %{primary: "red"}

# mutate object is not allowed
# colors.primary = "blue" | CompileError
```

The iead of how we handle data inside `elixir`: all the data structures we ever create.
We do not manipulate, we do not change. We create a new data structure out of the
existing one with some litte tiny difference to it. Whatever change we might want to make.

2 ways to update a `map` in `elixir`

- using `function`

  ```elixir
    colors = %{primary: "red"}
    Map.put(colors, :primary, "blue")
  ```

- using interesting `syntax`: this syntax basedupdate to a map can only be used when
  we are updating an existing property.

  ```elixir
    colors = %{primary: "red"}
    %{ colors | primary: "blue" }
  ```

### Tuples

```elixir
tuples = { "red", "green", "blue"}
```

Tuples with pattern matching

```elixir
tuples = { "red", "green", "blue"}

{ red_color, green_color, blue_color } = tuples
```
