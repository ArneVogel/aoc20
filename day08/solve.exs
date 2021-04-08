[file] = System.argv

input = File.read!(file) 
        |> String.split("\n", trim: true) 

defmodule Console do
   defstruct pc: 0, acc: 0
end

defmodule Solution1 do
  def solve(input) do
    instructions = Enum.map(input, &parse/1)
    console = run(%Console{}, instructions, MapSet.new())
    IO.puts console.acc
  end

  def run(console, instructions, steps) do
    new_console = step(Enum.at(instructions, console.pc), console)
    case MapSet.member?(steps, new_console.pc) do
      true ->
        console
      _ ->
        steps = MapSet.put(steps, new_console.pc)
        run(new_console, instructions, steps)
    end
  end

  def parse(line) do
    [op, arg] = String.split(line, " ")
    %{op => String.to_integer(arg)}
  end

  def step(%{"nop" => _}, console) do
    pc = console.pc + 1
    acc = console.acc
    %Console{pc: pc, acc: acc}
  end

  def step(%{"acc" => value}, console) do
    pc = console.pc + 1
    acc = console.acc + value
    %Console{pc: pc, acc: acc}
  end

  def step(%{"jmp" => value}, console) do
    pc = console.pc + value
    acc = console.acc
    %Console{pc: pc, acc: acc}
  end
end

defmodule Solution2 do
  def solve(input) do
    instructions = Enum.map(input, &parse/1)
    [{:ok, console}] = Enum.map(0..length(instructions), fn(index) -> 
      case Enum.at(instructions, index) do
        %{"nop" => value} ->
          List.replace_at(instructions, index, %{"jmp" => value})
        %{"jmp" => value} ->
          List.replace_at(instructions, index, %{"nop" => value})
        _ ->
          instructions
      end
    end) |> Enum.map(fn(x) -> 
      run(%Console{}, x, MapSet.new())
    end) |> Enum.filter(fn({result, _}) -> result == :ok end)
    IO.puts console.acc
  end

  def run(console, instructions, steps) do
    new_console = step(Enum.at(instructions, console.pc), console)
    member = MapSet.member?(steps, new_console.pc)
    at_end = new_console.pc >= length(instructions)
    case {member, at_end} do
      {true, _} ->
        {:error, console}
      {false, true} ->
        {:ok, new_console}
      _ ->
      steps = MapSet.put(steps, new_console.pc)
      run(new_console, instructions, steps)
    end
  end

  def parse(line) do
    [op, arg] = String.split(line, " ")
    %{op => String.to_integer(arg)}
  end

  def step(%{"nop" => _}, console) do
    pc = console.pc + 1
    acc = console.acc
    %Console{pc: pc, acc: acc}
  end

  def step(%{"acc" => value}, console) do
    pc = console.pc + 1
    acc = console.acc + value
    %Console{pc: pc, acc: acc}
  end

  def step(%{"jmp" => value}, console) do
    pc = console.pc + value
    acc = console.acc
    %Console{pc: pc, acc: acc}
  end

end


Solution1.solve(input)
Solution2.solve(input)
