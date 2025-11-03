defmodule TahinixTest do
  require Tahinix

  use ExUnit.Case

  setup do
    passing_tests = [(quote do: Tahinix.test("equivalence", do: Tahinix.assert(2 == 2))), (quote do: Tahinix.test("non-equivalence", do: Tahinix.assert(2 != 3)))]

    failing_tests =  [(quote do: Tahinix.test("equivalence", do: Tahinix.assert(2 != 2))), (quote do: Tahinix.test("non-equivalence", do: Tahinix.assert(2 == 3)))]

    failing_tests = [(quote do: Tahinix.skip_test("equivalence", do: Tahinix.assert(2 == 2))), (quote do: Tahinix.skip_test("non-equivalence", do: Tahinix.assert(2 != 3)))]
  end

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
    test "A test block of a passing equivalence test" do
      assert Tahinix.test("equivalence of 2 and 2", do: Tahinix.assert(2 == 2)) ==
               {:ok, ["equivalence of 2 and 2"]}
    end

    test "A test block of a passing non-equivalence test" do
      assert Tahinix.test("non-equivalence of 2 and 2", do: Tahinix.assert(2 != 2)) ==
               {:error, ["non-equivalence of 2 and 2", "Assertion failed: 2 != 2"]}
    end

    test "A test block of a failing equivalence test" do
      assert Tahinix.test("equivalence of 2 and 3", do: Tahinix.assert(2 == 3)) ==
               {:error, ["equivalence of 2 and 3", "Assertion failed: 2 == 3"]}
    end

    test "A test block of a failing non-equivalence test" do
      assert Tahinix.test("non-equivalence of 2 and 3", do: Tahinix.assert(2 != 3)) ==
               {:ok, ["non-equivalence of 2 and 3"]}
    end
  end

  describe "skip_test function allows for skipping of the test" do
    test "The skip_test/2 function returns {:ok, :skipped_test, [test_name]}" do
      assert Tahinix.skip_test("equivalence of 2 and 3", do: Tahinix.assert(2 == 3)) ==
               {:ok, :skipped_test, ["equivalence of 2 and 3"]}
    end
  end

  describe "Tests for the describe block" do
    test "describe block where all tests pass", %{passing_tests: passing_tests} do

      describe_block = Tahinix.describe( "passing_tests", passing_tests)

      assert describe_block == {:ok, "passing_tests", [
        %{pass: ["equivalence", "non-equivalene"]},
        %{fail: []},
        %{skip: []}
      ]
    }
    end

    test "describe block where all tests fail" do
    end

    test "describe block where all tests are skipped" do
    end

    test "describe block where some tests pass & some fail" do
    end

    test "describe block where some tests pass and skip" do
    end

    test "describe block where some tests fail and skip" do
    end

    test "describe block where some tests pass, fail and skip" do
    end
  end
end
