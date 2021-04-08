[file, limit] = System.argv

input = File.read!(file) 
        |> String.split("\n", trim: true) 
limit = String.to_integer(limit)

defmodule Solution1 do
  def solve(input, limit) do
    input = input |> Enum.map(&String.to_integer/1)
    IO.puts test(input, limit, limit)
  end

  def test(input, curr_index, limit) do
    preamble = input |> Enum.slice((curr_index-limit)..curr_index)
    target = Enum.at(input, curr_index)
    valid = preamble |> Enum.filter(fn(x) -> 
      anti = target - x
      Enum.member?(preamble, anti) and x != anti
    end)
    case length(valid) > 0 do
      false ->
        target
      _ ->
        test(input, curr_index+1, limit)
    end
  end
end

defmodule Solution2 do
  def solve(input, limit) do
    input = input |> Enum.map(&String.to_integer/1)
    target = test(input, limit, limit)
    IO.puts set(input, target, 0, 1)
  end

  def set(input, target, curr_index, take) do
    set = input |> Enum.slice(curr_index..(curr_index+take))
    sum = set |> Enum.sum
    finished = sum == target
    smaller = sum < target
    case {finished, smaller} do
      {true, _} ->
        Enum.min(set) + Enum.max(set)
      {false, true} ->
        set(input, target, curr_index, take+1)
      {false, false} ->
        set(input, target, curr_index+1, 1)
    end
  end

  def test(input, curr_index, limit) do
    preamble = input |> Enum.slice((curr_index-limit)..curr_index)
    target = Enum.at(input, curr_index)
    valid = preamble |> Enum.filter(fn(x) -> 
      anti = target - x
      Enum.member?(preamble, anti) and x != anti
    end)
    case length(valid) > 0 do
      false ->
        target
      _ ->
        test(input, curr_index+1, limit)
    end
  end

end


Solution1.solve(input, limit)
Solution2.solve(input, limit)
