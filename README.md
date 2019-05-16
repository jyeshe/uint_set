# UintSet

Tweet: I had a lot of fun implementing a new set type in @elixirlang to learn about protocols. It only stores integers >= 0 by using a (big) integer as a bitmap, so intersection is implemented with bitwise AND, union is bitwise OR etc. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `uint_set` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:uint_set, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/uint_set](https://hexdocs.pm/uint_set).

