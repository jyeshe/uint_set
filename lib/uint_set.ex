defmodule UintSet do
  @moduledoc """
  Documentation for UintSet.


  def count_ones(bigint):
    count = 0
    while bigint:
        count += bigint & 1
        bigint >>= 1
    return count

  """

  use Bitwise, only_operators: true

  def count_ones(bigint) when bigint >= 0 do
    count_ones(bigint, 0)
  end

  defp count_ones(0, count), do: count

  defp count_ones(bigint, count) do
    count = count + (bigint &&& 1)
    bigint = bigint >>> 1
    count_ones(bigint, count)
  end
end
