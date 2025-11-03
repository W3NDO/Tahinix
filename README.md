# Tahinix

A test runner to learn about meta-programming in elixir

Idea source from [here](https://projectbook.code.brettchalupa.com/libraries/unit-testing-lib.html)
Inspiration from RSpec and Mix test.

# Specs
## How does the the test syntax look like?
- For simplicity's sake, we will copy ExUnit's syntax

```
test "greets the world" do
  assert Sample.world() == :world
end
```

## Support for basic equals comparison

## Write a test runner that executes the tests. 
1. If the tests pass, exit with 0 status
2. If the tests fail, output what failed, exit with a non-zero status


Read the [docs](./docs/quote_unquote.md)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tahinix` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tahinix, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/tahinix>.

