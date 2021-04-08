[file] = System.argv

input = File.read!(file) 
        |> String.split("\n", trim: true) 

defmodule Solution1 do
  def solve(input) do
    [max, busses] = input
    max = String.to_integer(max)
    {id,time} = String.split(busses, ",", trim: true) 
             |> Enum.filter(fn(x) -> x != "x" end) 
             |> Enum.map(fn(x) -> String.to_integer(x) end)
             |> Enum.map(fn(x) -> {x, x * (div(max, x)+1)} end)
             |> Enum.min_by(fn({_,x}) -> x end)
    IO.puts id * (time-max)
  end
end

defmodule Chinese do
  def remainder(mods, remainders) do
    max = Enum.reduce(mods, fn x,acc -> x*acc end)
    Enum.zip(mods, remainders)
    |> Enum.map(fn {m,r} -> Enum.take_every(r..max, m) |> MapSet.new end)
    |> Enum.reduce(fn set,acc -> MapSet.intersection(set, acc) end)
    |> MapSet.to_list
  end
end
 
defmodule Solution2 do
  def solve(input) do
    [_,input] = input
    {a,b} = String.split(input, ",", trim: true) 
            |> Enum.with_index 
            |> Enum.filter(fn({e,_}) -> e != "x" end)
            |> Enum.map(fn({e,i}) -> {String.to_integer(e), i} end)
            |> Enum.map(fn({e,i}) -> {e, e-i} end)
            |> Enum.unzip
    IO.inspect [b,a] # solve with sagemaths crt(b,a)
    #IO.inspect Chinese.remainder(a,b)
  end
end



Solution1.solve(input)
Solution2.solve(input)
