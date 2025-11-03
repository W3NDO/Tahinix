# The beginning
## Quote
First, we need to understand how ExUnit tests are internally represented on the AST. 

We use Elixir's `quote` and `unquote` methods. `Quote` allows you to get an internal representation of your expression as the AST. For intance:

```
iex> quote do: 1+2

{:+, [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]], [1, 2]}
```

- The first element, `:+`, is an atom denoting the function call, or another tuple, representing a nested node in the AST.
- The second element, `[context: Elixir, imports: [{1, Kernel}, {2, Kernel}]]`, represents metadata about the expression
- The third element is a list of arguments for the function call.

Interestingly, this AST representation `{:+, [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]], [1, 2]}` is exactly what the compiler sees. Other languages, such as flavours of Lisp will have you write the source directly as an AST. Elixir however allows you to convert from high-level source to low-level AST with a simple `quote` invocation. 

Next thing we need to understand about ASTs in Elixir is that some literals will have the same representation as high-level literals. Namely, `atoms, numbers, strings, lists` and `tuples`

```
iex> quote do: :atom #atoms
:atom
iex> quote do: 123 #numbers
123
iex> quote do: 3.14 #numbers
3.14
iex> quote do: [1, 2, 3] #lists
[1, 2, 3]
iex> quote do: "string" #strings
"string"
iex> quote do: {:ok, 1} #tuples
{:ok, 1}
iex> quote do: {:ok, [1, 2, 3]} #tuples
{:ok, [1, 2, 3]}
```

## Unquote
The `unquote` Macro allows values to be injected into the AST that is being defined. These allows the outside bound `variables, epxressions` and `blocks` to be injected into the AST. For instance: 

```
iex> number = 5
iex> ast = quote do
...>    number * 10
...> end
{:*, [context: Elixir, import: Kernel], [{:number, [], Elixir}, 10]}
```

Here we see that the value of `number` was not injected into the AST. We instead got a local reference for `number` provided. However,

```
iex> number = 5
iex> ast = quote do
...>    unquote(number) * 10
...> end
{:*, [context: Elixir, import: Kernel], [5, 10]}
```
Here because we called `unquote(number)` the value 5 gets injected into the AST.

`Quote` and `Unquote` allow you to build ASTs without fumbling with the AST by hand. 

## Building the test runner.

Now let's start from the bottom. What is the basic building block of a test? I think it is the `assert` call. This checks the equivalency of your function being tested and the expected result. 

```
assert MyFun.sum(2,5) == 7
```

I think we should build an implementation of this function.

Side Note: I am a big proponent for TDD, so we start by builidng specs for our assert function. 

We define a function `assert/1` which takes one argument that must be an expression checking equivalency.

```
iex> Tahinix.assert(2 == 2)
.
```

In our tests, we check the cases where we use `:!=` and `:==`

```
defmodule TahinixTest do
  require Tahinix

  use ExUnit.Case

  test "assert returns non-zero value when tests fail equivalence" do
    assert Tahinix.assert(2 == 4) == {:error, "Assertion failed: 2 == 4"}
  end

  test "assert returns non-zero value when tests fail non-equivalence" do
    assert Tahinix.assert(2 != 2) == {:error, "Assertion failed: 2 != 2"}
  end

  test "assert returns 0 when tests pass equivalence" do
    assert Tahinix.assert(2 != 4) == :ok
  end

  test "assert returns 0 when tests pass non-equivalence" do
    assert Tahinix.assert(2 == 2) == :ok
  end
end
```


Now to make our tests pass, we start by implementing the code for `:==` function first. We use pattern matching in the atributes in order to get our left hand side(lhs) and right hand side(rhs)

```
  #{:==, _, [lhs, rhs]}
  defmacro assert({:==, _, [lhs, rhs]}) do
    quote do
      lhs = unquote(lhs)
      rhs = unquote(rhs)
      result = lhs == rhs

      case result do
        false -> {:error, "Assertion failed: #{lhs} == #{rhs}"}
        _ -> :ok
      end
    end
  end
```

This will match expressions of the form `lhs == rhs`, eg: `2 == 2`. By having `lhs` and `rhs` in the head, we bind these values to the variable names, which we then pass to `unquote`. 

We then use case to get our return value. If the result if false, we return a tuple `{:error, reason_for_error}`. Otherwise we retun `:ok`

Similarly for the assert `:!=` we pattern match in the function head to get

```
#{:!=, _, [lhs, rhs]}
  defmacro assert({:!=, _, [lhs, rhs]}) do
    quote do
      lhs = unquote(lhs)
      rhs = unquote(rhs)
      result = lhs != rhs

      case result do
        false -> {:error, "Assertion failed: #{lhs} != #{rhs}"}
        _ -> :ok
      end
    end
  end
```

When we run our tests, we find that they are all green now. 

![Test pass](./images/tests%20pass%201.png)

The question now remains, how complex an expression could we include in the left hand side? Let us right some tests and see what we can add in. 

```
test "Assert returns :ok when tests pass with a complex lhs function" do
    assert Tahinix.assert(5 * 2 == 10) == :ok
end

test "Assert returns :error when tests fail with complex lhs" do
    assert Tahinix.assert(5 * 2 == 12) == {:error, "Assertion failed: 5 * 2 == 12"}
end
```

Finally, can we test assertions on the output of functions? For instance, 
```
    iex> Tahinix.assert(MyMod.say_hello == :hello)
    :ok
```







References: 
1. [Metaprogramming in Elixir by Chris McCord](https://pragprog.com/book/cmelixir/metaprogramming-elixir)