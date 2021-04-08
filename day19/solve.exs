[file] = System.argv

input = File.read!(file) 
        |> String.split("\n\n", trim: true) 

defmodule Solution1 do
  def solve([rules, words]) do
    rules = rules 
            |> String.split("\n", trim: true) 
            |> Enum.map(&parse/1)
    words = words |> String.split("\n", trim: true)
    grammar = to_map(rules, %{})
    IO.inspect grammar
  end

  def to_map([], m) do m end
  def to_map([[key, value]|rest], m) do
    m = Map.put(m, key, value)
    to_map(rest, m)
  end

  def parse(rule) do
    case String.contains?(rule, "\"") do
      true -> parse_terminal(rule)
      _ -> parse_nonterminal(rule)
    end
  end
  def parse_terminal(rule) do
    word = String.split(rule, "\"") |> Enum.at(1)
    [name(rule), word]
  end
  def parse_nonterminal(rule) do
    rules = String.split(rule, ": ") 
            |> Enum.at(1)
            |> String.split(" | ")
            |> Enum.map(fn(x) -> 
              String.split(x, " ", trim: true)
                |> Enum.map(&String.to_integer/1)
            end)
    [name(rule), rules]
  end
  def name(rule) do
    String.split(rule, ":") |> Enum.at(0) |> String.to_integer
  end
end

defmodule Solution2 do
  def solve(input) do
  end
end

Solution1.solve(input)
Solution2.solve(input)
