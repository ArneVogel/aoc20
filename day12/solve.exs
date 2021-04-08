[file] = System.argv

input = File.read!(file) 
        |> String.split("\n", trim: true) 

defmodule Solution1 do
  def solve(input) do
    input = Enum.map(input, &String.split_at(&1, 1)) 
            |> Enum.map(fn({l, n}) -> {l, String.to_integer(n)} end)
    #[E,S,W,N]
    [dirs, _] = step(input, [0,0,0,0],0)
    e = Enum.at(dirs, 0)
    s = Enum.at(dirs, 1)
    w = Enum.at(dirs, 2)
    n = Enum.at(dirs, 3)
    IO.puts abs(n-s) + abs(e-w)
  end

  def step([curr | tail], moves, dir) do
    [moves, dir] = calc(curr, moves, dir)
    step(tail, moves, dir)
  end
  def step([], moves, dir) do
    [moves, dir]
  end

  def calc({"F", value}, moves, dir) do
    a = Enum.at(moves,dir)
    moves = List.replace_at(moves, dir, a+value)
    [moves, dir]
  end
  def calc({"R", value}, moves, dir) do
    r = div(value, 90)
    dir = Integer.mod(dir + r, 4)
    [moves, dir]
  end
  def calc({"L", value}, moves, dir) do
    r = div(value, 90)
    dir = Integer.mod(dir - r, 4)
    [moves, dir]
  end
  def calc(curr, moves, dir) do
    {letter, value} = curr
    d = dir(letter)
    a = Enum.at(moves,d)
    moves = List.replace_at(moves, d, a+value)
    [moves, dir]
  end

  def dir("E") do 0 end
  def dir("S") do 1 end
  def dir("W") do 2 end
  def dir("N") do 3 end
end

defmodule Solution2 do
  def solve(input) do
    input = Enum.map(input, &String.split_at(&1, 1)) 
            |> Enum.map(fn({l, n}) -> {l, String.to_integer(n)} end)
    #[E,S,W,N]
    {dirs, _} = step(input, [0,0,0,0], [10,0,0,1])
    e = Enum.at(dirs, 0)
    s = Enum.at(dirs, 1)
    w = Enum.at(dirs, 2)
    n = Enum.at(dirs, 3)
    IO.puts abs(n-s) + abs(e-w)
  end

  def step([curr | tail], ship, wp) do
    {ship, wp} = calc(curr, ship, wp)
    step(tail, ship, wp)
  end
  def step([], ship, wp) do
    {ship, wp}
  end

  def calc({"F", value}, ship, wp) do
    move = Enum.map(wp, fn(x) -> x*value end)
    ship = Enum.zip(ship, move) |> Enum.map(fn({a,b}) -> a+b end)
    {ship, wp}
  end
  def calc({"R", value}, ship, wp) do
    r = div(value, 90)
    wp = rotate("R", wp, r)
    {ship, wp}
  end
  def calc({"L", value}, ship, wp) do
    r = div(value, 90)
    wp = rotate("L", wp, r)
    {ship, wp}
  end
  def calc(curr, ship, wp) do
    {letter, value} = curr
    d = dir(letter)
    a = Enum.at(wp,d)
    wp = List.replace_at(wp, d, a+value)
    {ship, wp}
  end

  def dir("E") do 0 end
  def dir("S") do 1 end
  def dir("W") do 2 end
  def dir("N") do 3 end
  
  def rotate("L", list, 0) do list end
  def rotate("R", list, 0) do list end
  def rotate("R", list, num) do
    a = Enum.at(list, length(list)-1)
    list = List.delete_at(list, length(list)-1)
    list = List.insert_at(list, 0, a)
    rotate("R", list, num-1)
  end
  def rotate("L", list, num) do
    a = Enum.at(list, 0)
    list = List.delete_at(list, 0)
    list = List.insert_at(list, length(list), a)
    rotate("L", list, num-1)
  end

end


Solution1.solve(input)
Solution2.solve(input)
