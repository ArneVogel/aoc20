[file] = System.argv

input = File.read!(file) 
        |> String.split("\n", trim: true) 

defmodule Solution1 do
  def solve(input) do
    input = Enum.map(input, fn(x) -> 
      String.split(x, "", trim: true) |> Enum.filter(fn(y) -> y != " " end)
    end)
    IO.inspect Enum.map(input, fn(line) -> evaluate(line) end) |> Enum.sum
  end

  def evaluate(line) do
    ending = length(line)
    {open, close} = find_open_close(line, 0, 0)
    [base | operations ] = Enum.slice(line, open..close) |> List.delete("(") |> List.delete(")")
    base = to_int(base)
    operations = Enum.chunk_every(operations, 2)
    before_eval = range(line, 0, open-1) 
    after_eval = Enum.slice(line, close+1..length(line)-1)
    line = before_eval ++ [eval(base, operations)] ++ after_eval
    case {open, close} == {0, ending} do
      true -> eval(base,operations)
      _ -> evaluate(line)
    end
  end

  def range(_line, _min, -1) do
    []
  end

  def range(line, min, max) do
    Enum.slice(line, min..max)
  end

  def to_int(int) when is_number(int) do
    int
  end
  def to_int(string) do
    String.to_integer(string)
  end

  def eval(base, []) do base end
  def eval( base, [[op, num] | rest]) do
    num = to_int(num)
    case op do
      "*" -> eval(base*num, rest)
      "+" -> eval(base+num, rest)
      _   -> IO.puts "WHAT???"
    end
  end

  def find_open_close([], _, count) do
    {0,count}
  end
  def find_open_close([char | _rest], open, count) when char == ")" do
    {open, count}
  end
  def find_open_close([char | rest], _open, count) when char == "(" do
    find_open_close(rest, count, count+1)
  end
  def find_open_close([_char | rest], open, count) do
    find_open_close(rest, open, count+1)
  end

end

defmodule Solution2 do
  def solve(input) do
    input = Enum.map(input, fn(x) -> 
      String.split(x, "", trim: true) |> Enum.filter(fn(y) -> y != " " end)
    end)
    IO.inspect Enum.map(input, fn(line) -> evaluate(line) end) |> Enum.sum
  end

  def evaluate(line) do
    ending = length(line)
    {open, close} = find_open_close(line, 0, 0)
    open_to_close = Enum.slice(line, open..close) |> List.delete("(") |> List.delete(")")
    [base | operations ] = plus_first(open_to_close)
    base = to_int(base)
    operations = Enum.chunk_every(operations, 2)
    before_eval = range(line, 0, open-1) 
    after_eval = Enum.slice(line, close+1..length(line)-1)
    res = eval(base,operations)
    line = before_eval ++ [res] ++ after_eval
    case {open, close} == {0, ending} do
      true -> res
      _ -> evaluate(line)
    end
  end

  def range(_line, _min, -1) do
    []
  end

  def range(line, min, max) do
    Enum.slice(line, min..max)
  end

  def to_int(int) when is_number(int) do
    int
  end
  def to_int(string) do
    String.to_integer(string)
  end

  def plus_first(line) do 
    plus = Enum.find_index(line, fn(x) -> x == "+" end)
    case plus do
      nil -> line
      _ -> 
        a = to_int(Enum.at(line, plus-1))
        b = to_int(Enum.at(line, plus+1))
        line = List.replace_at(line, plus, a+b) |> List.delete_at(plus-1) |> List.delete_at(plus)
        plus_first(line)
    end
  end
  def eval(base, []) do base end
  def eval( base, [[op, num] | rest]) do
    num = to_int(num)
    case op do
      "*" -> eval(base*num, rest)
      "+" -> eval(base+num, rest)
      _   -> IO.puts "WHAT???"
    end
  end

  def find_open_close([], _, count) do
    {0,count}
  end
  def find_open_close([char | _rest], open, count) when char == ")" do
    {open, count}
  end
  def find_open_close([char | rest], _open, count) when char == "(" do
    find_open_close(rest, count, count+1)
  end
  def find_open_close([_char | rest], open, count) do
    find_open_close(rest, open, count+1)
  end
end

Solution1.solve(input)
Solution2.solve(input)
