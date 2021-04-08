[file] = System.argv

input = File.read!(file) 
        |> String.split("\n", trim: true) 

defmodule Solution1 do
  def solve([input]) do
    input = String.split(input, ",", trim: true) |> Enum.map(&String.to_integer/1)
    IO.inspect run(input)
  end

  def run(numbers) when length(numbers) < 2020 do
    last = List.last(numbers)
    indexed = Enum.with_index(numbers) |> Enum.filter(fn({e,i}) -> e == last and i != length(numbers)-1 end)
    case length(indexed) do
      0 ->
        run(numbers ++ [0])
      _ ->
        {_, index} = List.last(indexed)
        run(numbers ++ [length(numbers) - index-1])
    end
  end
  def run(numbers) do
    List.last(numbers)
  end

end

defmodule Solution2 do
  def solve([input]) do
    #takes a minute
    last = String.split(input, ",", trim: true) 
           |> Enum.map(&String.to_integer/1)
           |> List.last

    numbers = String.split(input, ",", trim: true) 
            |> Enum.map(&String.to_integer/1) 
            |> Enum.with_index
            |> Enum.drop(-1)
            |> Enum.reduce(%{}, fn({e,i}, acc) -> Map.put(acc, e, i) end)
    IO.inspect run(numbers, last, length(String.split(input, ",", trim: true)))
  end

  def run(numbers, last_num, total) when total < 30000000 do
    ln = Map.get(numbers, last_num)
    numbers = Map.put(numbers, last_num, total-1)
    case ln do
      nil ->
        run(numbers, 0, total+1)
      _ ->
        run(numbers, total-ln-1, total+1)
    end
  end
  def run(_numbers, last_num, _total) do
    last_num
  end
end

Solution1.solve(input)
Solution2.solve(input)
