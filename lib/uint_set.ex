defmodule UintSet do
  @moduledoc """
  Functions that work on sets of integers >= 0.

  `UintSet` is an alternative set type in Elixir
  emulating the `MapSet` interface as closely as possible.
  `UintSet` was created to illustrate the construction of a functional
  data structure from scratch, using language features such as
  protocols, streams, doctests, and unit tests.

  A set can be constructed using `MapSet.new/0`:
      iex> UintSet.new()
      #UintSet<[]>

  An `UintSet` can contain only non-negative integers.
  By definition, sets can't contain duplicate elements:
  when inserting an element in a set where it's already present,
  the insertion is simply a no-op.
  """

  import BitOps

  defstruct bits: 0

  @doc """
  Returns a new `UintSet`.
  ## Examples
      iex> UintSet.new()
      #UintSet<[]>
  """
  def new(), do: %UintSet{}

  def new(bigint) when is_integer(bigint) and bigint >= 0 do
    %UintSet{bits: bigint}
  end

  def to_list(%UintSet{bits: bits}) do
    bits |> list_ones
  end

  def put(%UintSet{bits: bits}, element) do
    %UintSet{bits: set_bit(bits, element)}
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(map_set, opts) do
      concat(["#UintSet<", Inspect.List.inspect(UintSet.to_list(map_set), opts), ">"])
    end
  end
end
