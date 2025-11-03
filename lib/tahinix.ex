defmodule Tahinix do
  @moduledoc """
  Documentation for `Tahinix`.
  """

  # {:==, _, [lhs, rhs]}
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

  # {:!=, _, [lhs, rhs]}
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

  defmacro test(test_name, do: block) do
    quote do
      test_name = unquote(test_name)
      block = unquote(block)

      case block do
        :ok -> {:ok, [test_name]}
        {:error, reason} -> {:error, [test_name, reason]}
      end
    end
  end
end
