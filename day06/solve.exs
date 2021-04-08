[file] = System.argv

input = File.read!(file) 
        |> String.split("\n\n", trim: true) 

defmodule Solution1 do
  def solve(input) do
    abc = Enum.map(input, &String.replace(&1, "\n", ""))
          |> Enum.map(&String.split(&1, "", trim: true))
          |> Enum.map(&Enum.uniq/1)
          |> Enum.reduce(0, fn(x,acc) -> length(x) + acc end)
    IO.puts abc
  end
end

defmodule Solution2 do
  def solve(input) do
    abc = Enum.map(input, &String.split(&1, "\n", trim: true))
          |> Enum.map(fn(y) -> Enum.map(y, fn(x) -> String.split(x, "", trim: true) end) end)
          |> Enum.map(&all/1)
          |> Enum.map(&List.flatten/1)
          |> Enum.map(&Enum.uniq/1)
          |> Enum.reduce(0, fn(x,acc) -> length(x) + acc end)
    IO.puts abc
  end
  def all(lists) do
    for list <- lists do
      for letter <- list, Enum.all?(lists, &Enum.member?(&1, letter)) do
        letter
      end
    end
  end
end


Solution1.solve(input)
Solution2.solve(input)
