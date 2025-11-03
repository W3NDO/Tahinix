defmodule TahinixTest do
  require Tahinix

  use ExUnit.Case

  describe "Testing the assert function" do
    test "assert returns non-zero value when tests fail equivalence" do
      assert Tahinix.assert(2 == 4) == {:error, "Assertion failed: 2 == 4"}
    end

    test "assert returns non-zero value when tests fail non-equivalence" do
      assert Tahinix.assert(2 != 2) == {:error, "Assertion failed: 2 != 2"}
    end

    test "assert returns :ok when tests pass equivalence" do
      assert Tahinix.assert(2 != 4) == :ok
    end

    test "assert returns :ok when tests pass non-equivalence" do
      assert Tahinix.assert(2 == 2) == :ok
    end

    test "Assert returns :ok when tests pass with a complex lhs function" do
      assert Tahinix.assert(5 * 2 == 10) == :ok
    end

    test "Assert returns :error when tests fail with complex lhs" do
      assert Tahinix.assert(5 * 2 == 12) == {:error, "Assertion failed: 10 == 12"}
    end

    test "Assert returns :ok when tests pass with a complex lhs function on non-equivalence" do
      assert Tahinix.assert(5 * 2 != 10) == {:error, "Assertion failed: 10 != 10"}
    end

    test "Assert returns :error when tests fail with complex lhs on non-equivalence" do
      assert Tahinix.assert(5 * 2 != 12) == :ok
    end

    test "Assert returns :ok on equivalence of function output" do
      assert Tahinix.assert(Hello.say_hello() == "hello") == :ok
    end

    test "Assert returns :error on equivalence of function output" do
      assert Tahinix.assert(Hello.say_hello() == "hello_world") ==
               {:error, "Assertion failed: hello == hello_world"}
    end

    test "Assert returns :ok on non-equivalence of function output" do
      assert Tahinix.assert(Hello.say_hello() != "hello_world") == :ok
    end

    test "Assert returns :error on non-equivalence of function output" do
      assert Tahinix.assert(Hello.say_hello() != "hello") ==
               {:error, "Assertion failed: hello != hello"}
    end
  end

  describe "testing test blocks." do
  end
end
