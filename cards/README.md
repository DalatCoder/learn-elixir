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

## Lists and Strings

- Using bracket `[]`
- String in written inside `""` (convention)
- `iex` does not automatically reload or recompile our code whenever something changes.
  We can type `recompile` inside the shell to recompile our project.
