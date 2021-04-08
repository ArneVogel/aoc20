[file] = System.argv

input = File.read!(file) 
        |> String.split("\n", trim: true) 

defmodule Solution1 do
  def solve(input) do
    grid = input |> Enum.map(&String.split(&1, "", trim: true))
    height = length(Enum.at(grid, 0))
    width = length(grid)
    final = step(grid, width, height)
    IO.puts Enum.map(final, fn(row) -> 
      length(Enum.filter(row, fn(e) -> e == "#" end))
    end) |> Enum.sum
  end

  def step(grid, width, height) do
    indexed_grid = grid |> Enum.map(&Enum.with_index/1) |> Enum.with_index
    next_grid = indexed_grid |> Enum.map(fn({list, x}) -> 
      Enum.map(list, fn({element, y}) -> 
        case element do
          "#" ->
            cond do
              adjacent(grid, "#", x,y, width, height) >= 4 -> "L"
              true                                         -> "#"
            end
          "L" ->
            cond do
              adjacent(grid, "#", x,y, width, height) == 0 -> "#"
              true                                         -> "L"
            end
          "." -> "."
        end
      end)
    end)
    case next_grid == grid do
      true ->
        next_grid
      _ ->
        step(next_grid, width, height)
    end
  end

  def get_point(grid,x,y,max_width, max_height) do
    cond do
      x < 0           -> "."
      y < 0           -> "."
      x >= max_width  -> "."
      y >= max_height -> "."
      true            -> Enum.at(Enum.at(grid, x), y)
    end
  end

  def adjacent(grid,symbol,x,y,max_width, max_height) do
    a = get_point(grid,x+1,y  ,max_width, max_height)
    b = get_point(grid,x-1,y  ,max_width, max_height)
    c = get_point(grid,x-1,y+1,max_width, max_height)
    d = get_point(grid,x+1,y+1,max_width, max_height)
    e = get_point(grid,x-1,y-1,max_width, max_height)
    f = get_point(grid,x+1,y-1,max_width, max_height)
    g = get_point(grid,x  ,y+1,max_width, max_height)
    h = get_point(grid,x  ,y-1,max_width, max_height)
    match = Enum.filter([a,b,c,d,e,f,g,h], fn(x) -> x == symbol end)
    length(match)
  end
end

defmodule Solution2 do
  def solve(input) do
    grid = input |> Enum.map(&String.split(&1, "", trim: true))
    height = length(Enum.at(grid, 0))
    width = length(grid)
    #IO.puts adjacent(grid, "#", 4,2, width, height)
    final = step(grid, width, height)
    #final = []
    IO.puts Enum.map(final, fn(row) -> 
      length(Enum.filter(row, fn(e) -> e == "#" end))
    end) |> Enum.sum
  end

  def step(grid, width, height) do
    indexed_grid = grid |> Enum.map(&Enum.with_index/1) |> Enum.with_index
    next_grid = indexed_grid |> Enum.map(fn({list, x}) -> 
      Enum.map(list, fn({element, y}) -> 
        case element do
          "#" ->
            cond do
              adjacent(grid, "#", x,y, width, height) >= 5 -> "L"
              true                                         -> "#"
            end
          "L" ->
            cond do
              adjacent(grid, "#", x,y, width, height) == 0 -> "#"
              true                                         -> "L"
            end
          "." -> "."
        end
      end)
    end)
    case next_grid == grid do
      true ->
        next_grid
      _ ->
        step(next_grid, width, height)
    end
  end

  def get_point(grid,x,y,max_width, max_height) do
    cond do
      x < 0           -> "."
      y < 0           -> "."
      x >= max_width  -> "."
      y >= max_height -> "."
      true            -> Enum.at(Enum.at(grid, x), y)
    end
  end

  def get_next_point(grid, symbol, x,y, delta_x, delta_y, step, max_width, max_height) do
    curr_x = x + step * delta_x
    curr_y = y + step * delta_y
    pos = cond do
      curr_x < 0           -> "U"
      curr_y < 0           -> "U"
      curr_x >= max_width  -> "U"
      curr_y >= max_height -> "U"
      true            -> Enum.at(Enum.at(grid, curr_x), curr_y)
    end
    case pos do
      "." ->
        get_next_point(grid, symbol, x,y,delta_x,delta_y, step+1, max_width, max_height)
      "U" ->
        "."
      _ -> 
        #IO.inspect ["seen_at", curr_x, curr_y, step, delta_x, delta_y, x,y]
        pos
    end
  end

  def adjacent(grid,symbol,x,y,max_width, max_height) do
    a = get_next_point(grid,symbol,x,y,+1, 0,1,max_width, max_height)
    b = get_next_point(grid,symbol,x,y,-1, 0,1,max_width, max_height)
    c = get_next_point(grid,symbol,x,y,+1,+1,1,max_width, max_height)
    d = get_next_point(grid,symbol,x,y,+1,-1,1,max_width, max_height)
    e = get_next_point(grid,symbol,x,y,-1,+1,1,max_width, max_height)
    f = get_next_point(grid,symbol,x,y,-1,-1,1,max_width, max_height)
    g = get_next_point(grid,symbol,x,y, 0,+1,1,max_width, max_height)
    h = get_next_point(grid,symbol,x,y, 0,-1,1,max_width, max_height)
    #IO.inspect [a,b,c,d,e,f,g,h]
    match = Enum.filter([a,b,c,d,e,f,g,h], fn(x) -> x == symbol end)
    length(match)
  end

end


Solution1.solve(input)
Solution2.solve(input)
