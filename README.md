# UintSet

[`UintSet`](https://hexdocs.pm/uint_set/UintSet.html) is an alternative set type in Elixir,
designed to hold non-negative integer elements.

`UintSet` emulates the full `MapSet` interface,
except for `MapSet.size` which is replaced by `UintSet.length`.
Many of the `UintSet` doctests and unit tests were adapted from `MapSet`.

`UintSet` illustrates the construction of a functional data structure from scratch,
implementing protocols—`Inspect`, `Enumerable`, `Collectable`—and a stream.

All the content of an `UintSet` is represented by a single integer,
which in Elixir is limited only by available memory.
Each bit in that integer represents one element:
a bit `1` at position `n` means the number `n` is present in the set.
This allows set operations like union and intersection
to be implemented using fast bitwise operators.
See the source code of `UintSet.union` and `UintSet.intersection`.

See documentation at https://hexdocs.pm/uint_set/UintSet.html.

> This package was inspired by the excellent `intset` example from chapter 6 of
> _The Go Programming Language_, by Alan. A. A. Donovan and Brian W. Kernighan.
> The implementation in Elixir is much simpler because we can use a single (big) integer to hold the bit vector.
> The Go example manages an `uint64[]` slice which they need to grow and shrink on demand.
> Also, they need to loop over the slices to perform bitwise operations which
> in Elixir we do in a single expression like `bits1 &&& bits2`.

