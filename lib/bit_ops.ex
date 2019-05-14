defmodule BitOps do
  @moduledoc """
  Documentation for BitOps: bit-level operations.
  """

  use Bitwise, only_operators: true

  def count_ones(bigint) when is_integer(bigint) and bigint >= 0 do
    count_ones(bigint, 0)
  end

  defp count_ones(0, count), do: count

  defp count_ones(bigint, count) do
    count = count + (bigint &&& 1)
    bigint = bigint >>> 1
    count_ones(bigint, count)
  end

  def get_bit(bigint, index) do
    bigint >>> index &&& 1
  end

  def set_bit(bigint, index) do
    1 <<< index ||| bigint
  end

  def unset_bit(bigint, index) do
    if get_bit(bigint, index) == 1 do
      (1 <<< index) ^^^ bigint
    else
      bigint
    end
  end
end
