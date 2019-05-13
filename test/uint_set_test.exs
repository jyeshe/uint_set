defmodule UintSetTest do
  use ExUnit.Case, async: true
  doctest UintSet

  import UintSet

  def pow(base, exp) when base >= 0 do
    pow(base, exp, 1)
  end

  defp pow(_, 0, _), do: 1

  defp pow(base, 1, res), do: base * res

  defp pow(base, exp, res) do
    res = res * base
    pow(base, exp - 1, res)
  end

  test "count_ones -> 0" do
    assert count_ones(0) == 0
  end

  test "count_ones -> 1" do
    assert count_ones(1) == 1
    assert count_ones(0b10) == 1
    assert count_ones(0b100) == 1
    assert count_ones(pow(2, 100)) == 1
  end

  test "count_ones -> 2" do
    assert count_ones(0b11) == 2
    assert count_ones(0b101) == 2
    assert count_ones(0b110) == 2
    assert count_ones(0b1001) == 2
    assert count_ones(0b1010) == 2
    assert count_ones(pow(2, 100) + 1) == 2
  end

  test "count_ones -> 3" do
    assert count_ones(0b111) == 3
    assert count_ones(0b1011) == 3
    assert count_ones(0b1101) == 3
    assert count_ones(0b1110) == 3
    assert count_ones(pow(2, 100) + 3) == 3
  end

  test "count_ones -> many" do
    assert count_ones(0b1111_1111_1111) == 12
    assert count_ones(pow(2, 100) - 1) == 100
  end

end
