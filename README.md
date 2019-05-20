# UintSet

[`UintSet`](https://hexdocs.pm/uint_set/UintSet.html) is an alternative set type in Elixir,
designed to hold sets of small, non-negative integers.

`UintSet` emulates the full `MapSet` interface,
except for `MapSet.size` which is replaced by `UintSet.length`.
Many of the `UintSet` doctests and unit tests were adapted from `MapSet`.

`UintSet` illustrates the construction of a functional data structure from scratch,
implementing protocols—`Inspect`, `Enumerable`, `Collectable`—and a stream.

All the content of an `UintSet` is represented by a single integer,
which in Elixir is limited only by available memory.
Each bit in that integer represents one element:
a bit set to `1` at position `n` means the number `n` is present in the set.

```elixir
    iex> s = UintSet.new([0, 2, 3])    
    #UintSet<[0, 2, 3]>
    iex> s.bits                        
    13
    iex> s.bits |> Integer.to_string(2)
    "1101"
```

Using an integer as a bit vector we can use fast bitwise operators
for set operations like intersection and difference.
See the source code of `UintSet.intersection` and `UintSet.difference`.

Documentation with examples: https://hexdocs.pm/uint_set/UintSet.html.

## Source of this idea

This package was inspired by the excellent [`intset` example](https://github.com/adonovan/gopl.io/blob/master/ch6/intset/intset.go) from chapter 6 of
[_The Go Programming Language_](http://www.gopl.io/), by Alan. A. A. Donovan and Brian W. Kernighan.

Here is how Donovan & Kernighan introduce the example:

> A set represented by a map is very flexible but, for certain problems,
> a specialized representation may outperform it. For example, in domains 
> such as dataflow analysis where set elements are small non-negative integers,
> sets have many elements, and set operations like union and intersection are common,
> a *bit_vector* is ideal.

Implementing `intset` in Elixir is easier than in Go, because we can use a single (big) integer to hold the bit vector.
The Go example uses an `uint64[]` slice (dynamic array) to store elements in blocks of 64 bits. They need to grow and shrink the slice on demand, and they need to loop over slices performing bitwise operations in each 64-bit block, which
in Elixir we do in a single expression like `bits1 &&& bits2`.
