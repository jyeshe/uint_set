defmodule BitOps do
  @moduledoc """
  Documentation for BitOps: bit-level operations.
  """

  use Bitwise, only_operators: true

  @spec count_ones(non_neg_integer()) :: non_neg_integer()
  def count_ones(bigint) when is_integer(bigint) and bigint >= 0 do
    count_ones(bigint, 0)
  end

  defp count_ones(0, count), do: count

  defp count_ones(bigint, count) do
    count = count + (bigint &&& 1)
    count_ones(bigint >>> 1, count)
  end

  @spec get_bit(integer(), integer()) :: 0 | 1
  def get_bit(bigint, index) do
    (bigint >>> index) &&& 1
  end

  @spec set_bit(integer(), integer()) :: integer()
  def set_bit(bigint, index) do
    (1 <<< index) ||| bigint
  end

  @spec unset_bit(integer(), integer()) :: integer()
  def unset_bit(bigint, index) do
    if get_bit(bigint, index) == 1 do
      (1 <<< index) ^^^ bigint
    else
      bigint
    end
  end

  def list_ones(bigint) when is_integer(bigint) and bigint >= 0 do
    list_ones(bigint, 0, [])
  end

  defp list_ones(0, _index, list), do: Enum.reverse(list)

  defp list_ones(bigint, index, list) do
    if (bigint &&& 1) == 1 do
      list_ones(bigint >>> 1, index + 1, [index|list])
    else
      list_ones(bigint >>> 1, index + 1, list)
    end
  end

end
