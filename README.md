# UintSet

`UintSet` is an alternative set type in Elixir,
designed to hold only non-negative integer elements.

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
