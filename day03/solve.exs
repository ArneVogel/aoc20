[file] = System.argv

input = File.read!(file) 
        |> String.split("\n", trim: true) 

defmodule Solution1 do
  def solve(input) do
    IO.puts count(input, 0)
  end

  def count([], _), do: 0
  def count([line|rest], index) do
    length = String.length(line)
    add = case String.at(line, rem(index, length)) do
      "#" -> 
        1
      _ ->
        0
    end
    count(rest, index+3) + add
  end

end

defmodule Solution2 do
  def solve(input) do
    a = count(input, 0, 1, 1)
    b = count(input, 0, 3, 1)
    c = count(input, 0, 5, 1)
    d = count(input, 0, 7, 1)
    e = count(input, 0, 1, 2)
    IO.puts a*b*c*d*e
  end
  def count([], _, _, _), do: 0
  def count([line|rest], index, step_right, step_down) do
    length = String.length(line)
    add = case String.at(line, rem(index, length)) do
      "#" -> 
        1
      _ ->
        0
    end
    rest_lines = case step_down do
      1 ->
        rest
      _ ->
        remove_extra(rest)
    end
    count(rest_lines, index+step_right, step_right, step_down) + add
  end

  def remove_extra([_| tail]), do: tail
  def remove_extra(_), do: []
end


Solution1.solve(input)
Solution2.solve(input)
