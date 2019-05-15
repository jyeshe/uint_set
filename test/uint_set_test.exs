defmodule UintSetTest do
  # , async: true
  use ExUnit.Case
  doctest UintSet

  import UintSet

  test "to_list/1 -> []" do
    result = UintSet.new() |> to_list()
    assert result == []
  end

  test "to_list/1 -> [0]" do
    result = UintSet.new(bits: 1) |> to_list()
    assert result == [0]
  end

  test "to_list/1 -> [0, 1, 2, 3]" do
    result = UintSet.new(bits: 0b1111) |> to_list()
    assert result == [0, 1, 2, 3]
  end

  test "to_list/1 -> [1, 100]" do
    bigint = round(:math.pow(2, 100)) + 2

    result =
      UintSet.new(bits: bigint)
      |> to_list()

    assert result == [1, 100]
  end

  test "put/1" do
    [
      {UintSet.new(), 0, [0]},
      {UintSet.new(), 1, [1]},
      {UintSet.new(), 1000, [1000]}
    ]
    |> Enum.each(fn {initial, element, wanted} ->
      result = put(initial, element) |> to_list

      assert result == wanted,
             "{#{inspect(initial)}, #{element}, #{inspect(wanted)}} -> #{inspect(result)}"
    end)
  end

  test "into/1" do
    [
      [],
      [0],
      [1],
      [1, 2, 3],
      [1, 1000]
    ]
    |> Enum.each(fn given ->
      result = given |> Enum.into(UintSet.new()) |> to_list
      assert result == given, "{#{inspect(given)}} -> #{inspect(result)}"
    end)
  end

  test "member/1" do
    refute UintSet.new() |> UintSet.member?(0)
    assert UintSet.new([0]) |> UintSet.member?(0)
    assert UintSet.new([1, 1000]) |> UintSet.member?(1000)
    refute UintSet.new([1, 1000]) |> UintSet.member?(0)
  end

  # the following tests were adapted from elixir/map_set_test.exs

  test "equal?/2" do
    assert UintSet.equal?(UintSet.new(), UintSet.new())
    refute UintSet.equal?(UintSet.new(1..20), UintSet.new(2..21))
    assert UintSet.equal?(UintSet.new(1..120), UintSet.new(1..120))
  end

  test "union/2" do
    result = UintSet.union(UintSet.new([1, 3, 4]), UintSet.new())
    assert UintSet.equal?(result, UintSet.new([1, 3, 4]))

    result = UintSet.union(UintSet.new(5..15), UintSet.new(10..25))
    assert UintSet.equal?(result, UintSet.new(5..25))

    result = UintSet.union(UintSet.new(1..120), UintSet.new(1..100))
    assert UintSet.equal?(result, UintSet.new(1..120))
  end

  test "intersection/2" do
    result = UintSet.intersection(UintSet.new(), UintSet.new(1..21))
    assert UintSet.equal?(result, UintSet.new())

    result = UintSet.intersection(UintSet.new(1..21), UintSet.new(4..24))
    assert UintSet.equal?(result, UintSet.new(4..21))

    result = UintSet.intersection(UintSet.new(2..100), UintSet.new(1..120))
    assert UintSet.equal?(result, UintSet.new(2..100))
  end

  test "difference/2" do
    result = UintSet.difference(UintSet.new(2..20), UintSet.new())
    assert UintSet.equal?(result, UintSet.new(2..20))

    result = UintSet.difference(UintSet.new(2..20), UintSet.new(1..21))
    assert UintSet.equal?(result, UintSet.new())

    result = UintSet.difference(UintSet.new(1..101), UintSet.new(2..100))
    assert UintSet.equal?(result, UintSet.new([1, 101]))
  end

  test "disjoint?/2" do
    assert UintSet.disjoint?(UintSet.new(), UintSet.new())
    assert UintSet.disjoint?(UintSet.new(1..6), UintSet.new(8..20))
    refute UintSet.disjoint?(UintSet.new(1..6), UintSet.new(5..15))
    refute UintSet.disjoint?(UintSet.new(1..120), UintSet.new(1..6))
  end

  test "subset?/2" do
    assert UintSet.subset?(UintSet.new(), UintSet.new())
    assert UintSet.subset?(UintSet.new(1..6), UintSet.new(1..10))
    assert UintSet.subset?(UintSet.new(1..6), UintSet.new(1..120))
    refute UintSet.subset?(UintSet.new(1..120), UintSet.new(1..6))
  end

  test "delete/2" do
    result = UintSet.delete(UintSet.new(), 1)
    assert UintSet.equal?(result, UintSet.new())

    result = UintSet.delete(UintSet.new(1..4), 5)
    assert UintSet.equal?(result, UintSet.new(1..4))

    result = UintSet.delete(UintSet.new(1..4), 1)
    assert UintSet.equal?(result, UintSet.new(2..4))

    result = UintSet.delete(UintSet.new(1..4), 2)
    assert UintSet.equal?(result, UintSet.new([1, 3, 4]))
  end

  # the following test was adapted from the size/1 test in elixir/map_set_test.exs,
  # but here the function is length/1 because it runs in O(n) time

  test "length/1" do
    assert UintSet.length(UintSet.new()) == 0
    assert UintSet.length(UintSet.new(5..15)) == 11
    assert UintSet.length(UintSet.new(2..100)) == 99
  end

  test "Enumerable protocol" do
    # given, total, first, second, has_3, reversed
    [
      {[], 0, nil, nil, false, []},
      {[0], 0, 0, nil, false, [0]},
      {[1], 1, 1, nil, false, [1]},
      {[2, 3, 4], 9, 2, 3, true, [4, 3, 2]},
      {[3, 1000], 1003, 3, 1000, true, [1000, 3]}
    ]
    |> Enum.each(fn {given, total, first, second, has_3, reversed} ->
      set = given |> UintSet.new()
      assert total == set |> Enum.sum()
      assert first == set |> Enum.at(0)
      assert second == set |> Enum.at(1)
      assert has_3 == set |> Enum.member?(3)
      assert reversed == set |> Enum.reverse()
    end)
  end

  test "stream/1" do
    result =
      UintSet.new(1..5)
      |> UintSet.stream()
      |> Stream.into([])
      |> Enum.to_list()

    assert result == [1, 2, 3, 4, 5]
  end
end
