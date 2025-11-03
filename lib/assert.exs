defmodule Tahinixy do
  # {:==, _, [lhs, rhs]}
  defmacro assert({:==, _, [lhs, rhs]}) do
    quote do
      lhs = unquote(lhs)
      rhs = unquote(rhs)
      result = lhs == rhs

      case result do
        false -> IO.puts("Assertion failed: #{lhs} == #{rhs} ")
        _ -> IO.puts(".")
      end
    end
  end

  # {:!=, _, [lhs, rhs]}
  defmacro assert({:!=, _, [lhs, rhs]}) do
    quote do
      lhs = unquote(lhs)
      rhs = unquote(rhs)
      result = lhs != rhs

      case result do
        false -> IO.puts("Assertion failed: #{lhs} != #{rhs} ")
        _ -> IO.puts(".")
      end
    end
  end
end
