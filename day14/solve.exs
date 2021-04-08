[file] = System.argv

input = File.read!(file) 
        |> String.split("\n", trim: true) 

defmodule Solution1 do
  def solve(input) do
    input = input |> Enum.map(&parse/1)
    [_, mem] = run(input, 0,%{})
    IO.inspect Enum.map(mem, fn({_, x}) -> String.to_integer(x, 2) end) |> Enum.sum
  end

  def parse(line) do
    case String.starts_with?(line, "mem") do
      true ->
        [reg, _] = String.trim_leading(line, "mem[") |> String.split("]")
        value = Enum.at(String.split(line, " "),2)
        value = String.to_integer(value) |> Integer.to_string(2)
        {:mem, [String.to_integer(reg), value]}
      _ ->
        {:mask, Enum.at(String.split(line, " "), 2) }
    end
  end

  def run([], mask, mem) do [mask, mem] end
  def run([{:mask, m}| rest], _, mem) do
    run(rest, m, mem)
  end
  def run([{:mem, [reg, value]}| rest], mask, mem) do
    value = String.pad_leading(value, 36, "0")
    value = Enum.zip(String.graphemes(mask), String.graphemes(value)) 
            |> Enum.map(fn(x) -> apply(x) end)
    run(rest, mask, Map.put(mem, reg, to_string(value)))
  end
  
  def apply({"X", a}) do a end
  def apply({"0", _}) do "0" end
  def apply({"1", _}) do "1" end
end

defmodule Solution2 do
  def solve(input) do
    input = input |> Enum.map(&parse/1)
    [_, mem] = run(input, 0,%{})
    IO.inspect Enum.map(mem, fn({_, x}) -> x end) |> Enum.sum
  end

  def parse(line) do
    case String.starts_with?(line, "mem") do
      true ->
        [reg, _] = String.trim_leading(line, "mem[") |> String.split("]")
        value = Enum.at(String.split(line, " "),2)
        reg = String.to_integer(reg) |> Integer.to_string(2)
        {:mem, [reg, String.to_integer(value)]}
      _ ->
        {:mask, Enum.at(String.split(line, " "), 2) }
    end
  end

  def run([], mask, mem) do [mask, mem] end
  def run([{:mask, m}| rest], mask, mem) do
    run(rest, m, mem)
  end
  def run([{:mem, [reg, value]}| rest], mask, mem) do
    reg = String.pad_leading(reg, 36, "0")
    reg = Enum.zip(String.graphemes(mask), String.graphemes(reg)) 
            |> Enum.map(fn(x) -> apply(x) end)
    masks = perms(to_string(reg), [])
    mem = insert_all(masks, mem, value)
    run(rest, mask, mem)
  end

  def insert_all([], mem, value) do mem end
  def insert_all([mask | rest], mem, value) do
    mem = Map.put(mem, mask, value)
    insert_all(rest, mem, value)
  end

  def perms(mask, all) do
    a = String.replace(mask, "X", "1", global: false)
    b = String.replace(mask, "X", "0", global: false)
    case String.contains?(mask, "X") do
      true ->
        perms(a, all) ++ perms(b, all) |> Enum.uniq
      _ ->
        all ++ [a,b] |> Enum.uniq
    end
  end

  def apply({"0", a}) do a end
  def apply({"1", _}) do "1" end
  def apply({"X", _}) do "X" end
end



Solution1.solve(input)
Solution2.solve(input)
