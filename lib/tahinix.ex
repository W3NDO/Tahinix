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

  defmacro skip_test(test_name, do: _block) do
    quote do
      test_name = unquote(test_name)
      {:ok, :skipped_test, ["#{test_name}"]}
    end
  end

  defmacro describe(describe_block_name, do: list_of_tests) do
    quote do
      describe_block_name = unquote(describe_block_name)
      list_of_tests = unquote(list_of_tests)
      IO.inspect("Block Name: #{describe_block_name}. Tests: #{list_of_tests}")
      :ok

      # pass = []
      # fail = []
      # skip = []

      # describe_block_name = unquote(describe_block_name)
      # list_of_tests = unquote(list_of_tests)
      # Enum.each(list_of_tests, fn x->
      #   res = unquote(x)

      #   case res do
      #     {:ok, :skipped_test, [test_name]} -> skip = [test_name | skip]
      #     {:ok, [test_name] } -> pass = [test_name | pass]
      #     {:error, [test_name], _ } -> fail = [test_name | fail]
      #   end
      # end)
    end
  end
end
