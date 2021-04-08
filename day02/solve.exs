[file] = System.argv

input = File.read!(file) 
        |> String.split("\n", trim: true) 

defmodule Solution1 do
  def solve(input) do
    parsed = Enum.map(input, &parse/1)
    calculated = Enum.map(parsed, &occurrence/1)
    total = Enum.filter(calculated, &valid/1)
    IO.puts(length(total))
  end

  def occurrence(parsed) do
    occurrence = length(String.split(parsed.password, parsed.letter)) - 1
    Map.put(parsed, :occurrence, occurrence)
  end

  def valid(c) do
    c.occurrence in c.min..c.max
  end

  def parse(string) do
    [limits, letter_with_colon, password]= String.split(string, " ")
    [min, max] = String.split(limits, "-")
    letter = String.trim_trailing(letter_with_colon, ":")
    %{min: String.to_integer(min), max: String.to_integer(max), letter: letter, password: password}
  end
end

defmodule Solution2 do
  def solve(input) do
    parsed = Enum.map(input, &parse/1)
    total = Enum.filter(parsed, &valid/1)
    IO.puts(length(total))
  end

  def valid(c) do
    splits = c.password |> String.split("", trim: true) 
    first = Enum.at(splits, c.first-1)
    second = Enum.at(splits, c.second-1)
    (first == c.letter || second == c.letter) and not (first == second)
  end

  def parse(string) do
    [limits, letter_with_colon, password]= String.split(string, " ")
    [min, max] = String.split(limits, "-")
    letter = String.trim_trailing(letter_with_colon, ":")
    %{first: String.to_integer(min), second: String.to_integer(max), letter: letter, password: password}
  end
end


Solution1.solve(input)
Solution2.solve(input)
