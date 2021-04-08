[file] = System.argv

input = File.read!(file) 
        |> String.split("\n", trim: true) 

defmodule Solution1 do
  def solve(input) do
    {_, input} = input |> Enum.map(&String.to_integer/1) 
            |> Enum.sort 
            |> Enum.chunk_every(2,1)
            |> List.pop_at(-1)
    ones = input |> Enum.filter(fn([x,y]) -> x + 1 == y end)
    threes = input |> Enum.filter(fn([x,y]) -> x + 3 == y end)
    IO.puts (length(ones)+1) * (length(threes)+1)
  end
end

defmodule Solution2 do
  def solve(input) do
    input = input |> Enum.map(&String.to_integer/1) |> Enum.sort
    dp = [1 | Enum.map(0..length(input), fn(_) -> 0 end)]
    input = [0 | input] ++ [Enum.max(input)+3]
    IO.inspect(dp, width: :infinity)
    IO.inspect(input, width: :infinity)
    IO.puts abc(input, dp, 1)
  end

  def abc(input, dp, index) do
    n = Enum.at(input, index)
    m1 = to_int(n > Enum.at(input, index-1) and n-3 <= Enum.at(input, index-1))
    m2 = to_int(n > Enum.at(input, index-2) and n-3 <= Enum.at(input, index-2))
    m3 = to_int(n > Enum.at(input, index-3) and n-3 <= Enum.at(input, index-3))
    sum = m1 * Enum.at(dp, index-1) + m2 * Enum.at(dp,index-2) + m3 * Enum.at(dp,index-3)
    dp = List.replace_at(dp, index, sum)
    case index+1 == length(input) do
      true ->
    IO.inspect(dp, width: :infinity)
        sum
      false ->
    IO.inspect(dp, width: :infinity)
        abc(input, dp, index+1)
    end
  end

  def to_int(true) do 1 end
  def to_int(false) do 0 end
end


Solution1.solve(input)
Solution2.solve(input)
