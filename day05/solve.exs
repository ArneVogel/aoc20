[file] = System.argv

input = File.read!(file) 
        |> String.split("\n", trim: true) 

defmodule Solution1 do
  def solve(input) do
    solved = input |> Enum.map(&parse/1) |> Enum.map(&calc/1) |> Enum.max
    IO.puts solved
  end

  def parse(line) do
    {row, column} = String.split_at(line, 7)
    {row, _} = String.replace(row, "F", "0") |> String.replace("B", "1") |> Integer.parse(2)
    {column, _} = String.replace(column, "L", "0") |> String.replace("R", "1") |> Integer.parse(2)
    %{row: row, column: column}
  end
  
  def calc(seat) do
    seat.row * 8 + seat.column
  end
end

defmodule Solution2 do
  def solve(input) do
    solved = input |> Enum.map(&parse/1) |> Enum.map(&calc/1) |> Enum.sort
    find(solved)
  end

  def find([a,b|tail]) do
    if b-a != 1 do
      IO.puts(a+1)
    end
    find([b | tail])
  end
  def find(_) do end

  def print([head|tail]) do
    IO.puts(head)
    print(tail)
  end
  def print([]) do end

  def parse(line) do
    {row, column} = String.split_at(line, 7)
    {row, _} = String.replace(row, "F", "0") |> String.replace("B", "1") |> Integer.parse(2)
    {column, _} = String.replace(column, "L", "0") |> String.replace("R", "1") |> Integer.parse(2)
    %{row: row, column: column}
  end
  def calc(seat) do
    seat.row * 8 + seat.column
  end
end


Solution1.solve(input)
Solution2.solve(input)
