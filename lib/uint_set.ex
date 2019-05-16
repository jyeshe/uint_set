defmodule UintSet do
  @moduledoc """
    Functions that work on sets of integers >= 0.

    `UintSet` is an alternative set type in Elixir
    emulating the `MapSet` interface as closely as possible.
    `UintSet` illustrates the construction of a functional data structure from scratch,
    implementing the `Inspect`, `Enumerable`, and `Collectable` protocols.

    Many of the `UintSet` doctests and unit tests were adapted from `MapSet`.

    A set can be constructed using `UintSet.new/0`:

        iex> UintSet.new()
        #UintSet<[]>

    An `UintSet` can contain only non-negative integers.
    By definition, sets can't contain duplicate elements:
    when inserting an elem in a set where it's already present,
    the insertion is simply a no-op.

        iex> uint_set = UintSet.new()
        #UintSet<[]>
        iex> UintSet.put(uint_set, 3)
        #UintSet<[3]>
        iex> UintSet.put(uint_set, 2) |> UintSet.put(3)
        #UintSet<[2, 3]>

    `UintSet.new/1` accepts an enumerable of elements:

        iex> UintSet.new(1..5)
        #UintSet<[1, 2, 3, 4, 5]>

    An `UnitSet` is represented internally using the `%UintSet{}` struct.
    This struct can be used whenever there's a need to pattern match on something being a `MapSet`:

        iex> match?(%UintSet{}, UintSet.new())
        true

    The `%UintSet{}` struct contains a single field—`bits`—
    an integer which is used as a bitmap where each set bit represents
    a number present in the set.

    An empty set is represented by `bits = 0`:

        iex> empty = UintSet.new()
        iex> empty.bits
        0
        iex> UintSet.member?(empty, 0)
        false

    A set containing a single 0 is represented by `bits = 1`,
    because the bit at 0 is set, so the element 0 is present:

        iex> set_with_zero = UintSet.new([0])
        iex> set_with_zero.bits
        1
        iex> UintSet.member?(set_with_zero, 0)
        true

    A set with a single 2 is represented by `bits = 4`,
    because the bit at 2 is set, so the element 2 is present:

        iex> set_with_two = UintSet.new([2])
        iex> set_with_two.bits
        4
        iex> UintSet.member?(set_with_two, 2)
        true

    A set with the numbers 0 and 1 is represented by `bits = 3`,
    because 3 is 0b11, so the bits 0 and 1 are set:

        iex> set_with_zero_and_one = UintSet.new([0, 1])
        #UintSet<[0, 1]>
        iex> set_with_zero_and_one.bits
        3

    The `UintSet.new/1` function also accepts a keyword argument
    setting the initial value of the `bits` field:

        iex> UintSet.new(bits: 15)
        #UintSet<[0, 1, 2, 3]>

    This is easier to understand using base 2 notation for the argument:

        iex> UintSet.new(bits: 0b1111)
        #UintSet<[0, 1, 2, 3]>


  """

  use Bitwise, only_operators: true

  import BitOps

  defstruct bits: 0

  @doc """
  Returns a new `UintSet`.
  ## Examples
      iex> UintSet.new()
      #UintSet<[]>
  """
  def new(), do: %UintSet{}

  def new(bits: bigint) when is_integer(bigint) and bigint >= 0 do
    %UintSet{bits: bigint}
  end

  def new(enumerable) do
    Enum.reduce(enumerable, %UintSet{}, &UintSet.put(&2, &1))
  end

  def new(enumerable, transform) when is_function(transform, 1) do
    enumerable
    |> Stream.map(transform)
    |> new
  end

  def to_list(%UintSet{bits: bits}) do
    bits |> list_ones
  end

  def put(%UintSet{bits: bits}, elem) do
    %UintSet{bits: set_bit(bits, elem)}
  end

  @doc """
  Deletes `value` from `uint_set`.
  Returns a new set which is a copy of `uint_set` but without `value`.
  ## Examples
      iex> uint_set = UintSet.new([1, 2, 3])
      iex> UintSet.delete(uint_set, 4)
      #UintSet<[1, 2, 3]>
      iex> UintSet.delete(uint_set, 2)
      #UintSet<[1, 3]>
  """
  def delete(%UintSet{bits: bits}, elem) do
    %UintSet{bits: unset_bit(bits, elem)}
  end

  def member?(%UintSet{bits: bits}, elem) do
    get_bit(bits, elem) == 1
  end

  def equal?(%UintSet{bits: bits1}, %UintSet{bits: bits2}) do
    bits1 == bits2
  end

  @doc """
  Returns the number of elements in `uint_set`.
  This function is named `length` because it needs to traverse the `uint_set`,
  so it runs on O(n) time. The corresponding function in `MapSet` is `size`.

  ## Example

      iex> UintSet.length(UintSet.new([10, 20, 30]))
      3
  """
  def length(%UintSet{bits: bits}) do
    bits |> count_ones
  end

  def union(%UintSet{bits: bits1}, %UintSet{bits: bits2}) do
    %UintSet{bits: bits1 ||| bits2}
  end

  def intersection(%UintSet{bits: bits1}, %UintSet{bits: bits2}) do
    %UintSet{bits: bits1 &&& bits2}
  end

  @doc """
  Returns a set that is `uint_set1` without the members of `uint_set2`.

  ## Examples

      iex> UintSet.difference(UintSet.new([1, 2]), UintSet.new([2, 3, 4]))
      #UintSet<[1]>
  """
  def difference(%UintSet{bits: bits1}, %UintSet{bits: bits2}) do
    %UintSet{bits: bits1 &&& bits2 ^^^ bits1}
  end

  @doc """
  Checks if `uint_set1` and `uint_set2` have no members in common.

  ## Examples

      iex> UintSet.disjoint?(UintSet.new([1, 2]), UintSet.new([3, 4]))
      true
      iex> UintSet.disjoint?(UintSet.new([1, 2]), UintSet.new([2, 3]))
      false
  """
  def disjoint?(%UintSet{bits: bits1}, %UintSet{bits: bits2}) do
    (bits1 &&& bits2) == 0
  end

  def subset?(set1, set2) do
    difference(set1, set2).bits == 0
  end

  def stream(%UintSet{bits: bits}) do
    stream_ones(bits)
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(uint_set, opts) do
      concat(["#UintSet<", Inspect.List.inspect(UintSet.to_list(uint_set), opts), ">"])
    end
  end

  defimpl Enumerable do
    def count(uint_set) do
      {:ok, UintSet.length(uint_set)}
    end

    def member?(uint_set, val) do
      {:ok, UintSet.member?(uint_set, val)}
    end

    def slice(_set) do
      {:error, __MODULE__}
    end

    def reduce(uint_set, acc, fun) do
      Enumerable.List.reduce(UintSet.to_list(uint_set), acc, fun)
    end
  end

  defimpl Collectable do
    def into(original) do
      collector_fun = fn
        set, {:cont, elem} -> UintSet.put(set, elem)
        set, :done -> set
        _set, :halt -> :ok
      end

      {original, collector_fun}
    end
  end
end
