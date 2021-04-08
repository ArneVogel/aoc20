[file] = System.argv

input = File.read!(file) 
        |> String.split("\n") 
        |> Enum.filter(fn(x) -> String.length(x) >= 1 end) 
        |> Enum.map(&String.to_integer/1)

defmodule Solution1 do
  def solve(input) do
    for a <- input, b <- input, a + b == 2020 do
      IO.puts "#{a*b}"
    end
  end
end

defmodule Solution2 do
  def solve(input) do
    for a <- input, b <- input, c <- input, a+b+c == 2020 do
      IO.puts "#{a*b*c}"
    end
  end
end


Solution1.solve(input)
Solution2.solve(input)
