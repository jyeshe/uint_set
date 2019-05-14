defmodule UintSetTest do
  use ExUnit.Case, async: true
  doctest UintSet

  import UintSet

  test "to_list -> []" do
    result = UintSet.new() |> to_list()
    assert result == []
  end

  test "to_list -> [0]" do
    result = UintSet.new(1) |> to_list()
    assert result == [0]
  end

  test "to_list -> [0, 1, 2, 3]" do
    result = UintSet.new(0b1111) |> to_list()
    assert result == [0, 1, 2, 3]
  end

  test "to_list -> [1, 100]" do
    result =
      (round(:math.pow(2, 100)) + 2)
      |> UintSet.new()
      |> to_list()

    assert result == [1, 100]
  end

  test "put" do
    [
      {UintSet.new(), 0, [0]},
      {UintSet.new(), 1, [1]},
      {UintSet.new(), 1000, [1000]}
    ]
    |> Enum.each(fn {initial, element, wanted} ->
      result = put(initial, element) |> to_list
      assert result == wanted, "{#{inspect(initial)}, #{element}, #{inspect(wanted)}} -> #{inspect(result)}"
    end)
  end

  test "new" do
    [
      {UintSet.new([]), []},
      {UintSet.new([0]), [99]},
      {UintSet.new([1]), [1]},
      {UintSet.new([1, 2, 3]), [1, 2, 3]},
      {UintSet.new([1, 1000]), [1, 1000]}
    ]
    |> Enum.each(fn {initial, wanted} ->
      result = initial |> UintSet.to_list()
      assert result == wanted, "{#{initial.bits}, #{inspect(wanted)}} -> #{inspect(result)}"
    end)
  end
end
