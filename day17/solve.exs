[file] = System.argv

input = File.read!(file) 
        |> String.split("\n", trim: true) 

defmodule Solution1 do
  def solve(input) do
    input = Enum.map(input, &String.split(&1, "", trim: true)) 
            |> Enum.map(&Enum.with_index/1) |> Enum.with_index 
            |> Enum.map(fn({row, index}) -> 
              Enum.map(row, fn({cell, row_index}) -> 
                case cell do
                  "#" ->
                    {index, row_index, 0}
                  _ -> nil
                end
              end)
            end) |> List.flatten |> Enum.filter(fn(x) -> x != nil end)
    input = MapSet.new(input)
    IO.inspect step(input, 0)
  end

  def step(cells, step) when step < 6 do
    {min_x, max_x, min_y, max_y, min_z, max_z} = limits(cells)
    a = Enum.map(min_x..max_x, fn(x) -> 
      Enum.map(min_y..max_y, fn(y) -> 
        Enum.map(min_z..max_z, fn(z) -> 
          cell = {x,y,z}
          member = MapSet.member?(cells, cell)
          next_state(member, cell, cells)
        end) 
      end) 
    end) |> List.flatten |> Enum.filter(fn(x) -> x != nil end)
    step(MapSet.new(a), step+1)
  end
  def step(cells, _) do
    MapSet.size(cells)
  end

  def next_state(true, cell, cells) do
    n = neighbors(cell, cells)
    case n do
      2 -> cell
      3 -> cell
      _ -> nil
    end
  end
  def next_state(false, cell, cells) do
    n = neighbors(cell, cells)
    case n do
      3 -> cell
      _ -> nil
    end
  end


  def neighbors({cx,cy,cz}, cells) do
    s = Enum.map(cx-1..cx+1, fn(x) -> 
      Enum.map(cy-1..cy+1, fn(y) -> 
        Enum.map(cz-1..cz+1, fn(z) -> 
          case MapSet.member?(cells, {x,y,z}) do
            true -> 1
            _ -> 0
          end
        end)
      end)
    end) |> List.flatten |> Enum.sum

    case MapSet.member?(cells, {cx,cy,cz}) do
      true -> s-1
      _ -> s
    end
  end

  def limits(cells) do
    {min_x,_,_} = Enum.min_by(cells, fn({x,_,_}) -> x end)
    {max_x,_,_} = Enum.max_by(cells, fn({x,_,_}) -> x end)
    {_,min_y,_} = Enum.min_by(cells, fn({_,y,_}) -> y end)
    {_,max_y,_} = Enum.max_by(cells, fn({_,y,_}) -> y end)
    {_,_,min_z} = Enum.min_by(cells, fn({_,_,z}) -> z end)
    {_,_,max_z} = Enum.max_by(cells, fn({_,_,z}) -> z end)
    {min_x-1, max_x+1, min_y-1, max_y+1, min_z-1, max_z+1}
  end
end

defmodule Solution2 do
  def solve(input) do
    input = Enum.map(input, &String.split(&1, "", trim: true)) 
            |> Enum.map(&Enum.with_index/1) |> Enum.with_index 
            |> Enum.map(fn({row, index}) -> 
              Enum.map(row, fn({cell, row_index}) -> 
                case cell do
                  "#" ->
                    {index, row_index, 0, 0}
                  _ -> nil
                end
              end)
            end) |> List.flatten |> Enum.filter(fn(x) -> x != nil end)
    input = MapSet.new(input)
    IO.inspect step(input, 0)
  end

  def step(cells, step) when step < 6 do
    {min_x, max_x, min_y, max_y, min_z, max_z, min_w, max_w} = limits(cells)
    a = Enum.map(min_x..max_x, fn(x) -> 
      Enum.map(min_y..max_y, fn(y) -> 
        Enum.map(min_z..max_z, fn(z) -> 
          Enum.map(min_w..max_w, fn(w) -> 
            cell = {x,y,z,w}
            member = MapSet.member?(cells, cell)
            next_state(member, cell, cells)
          end) 
        end) 
      end) 
    end) |> List.flatten |> Enum.filter(fn(x) -> x != nil end)
    step(MapSet.new(a), step+1)
  end
  def step(cells, _) do
    MapSet.size(cells)
  end

  def next_state(true, cell, cells) do
    n = neighbors(cell, cells)
    case n do
      2 -> cell
      3 -> cell
      _ -> nil
    end
  end
  def next_state(false, cell, cells) do
    n = neighbors(cell, cells)
    case n do
      3 -> cell
      _ -> nil
    end
  end


  def neighbors({cx,cy,cz,cw}, cells) do
    s = Enum.map(cx-1..cx+1, fn(x) -> 
      Enum.map(cy-1..cy+1, fn(y) -> 
        Enum.map(cz-1..cz+1, fn(z) -> 
          Enum.map(cw-1..cw+1, fn(w) -> 
            case MapSet.member?(cells, {x,y,z,w}) do
              true -> 1
              _ -> 0
            end
          end)
        end)
      end)
    end) |> List.flatten |> Enum.sum

    case MapSet.member?(cells, {cx,cy,cz,cw}) do
      true -> s-1
      _ -> s
    end
  end

  def limits(cells) do
    {min_x,_,_,_} = Enum.min_by(cells, fn({x,_,_,_}) -> x end)
    {max_x,_,_,_} = Enum.max_by(cells, fn({x,_,_,_}) -> x end)
    {_,min_y,_,_} = Enum.min_by(cells, fn({_,y,_,_}) -> y end)
    {_,max_y,_,_} = Enum.max_by(cells, fn({_,y,_,_}) -> y end)
    {_,_,min_z,_} = Enum.min_by(cells, fn({_,_,z,_}) -> z end)
    {_,_,max_z,_} = Enum.max_by(cells, fn({_,_,z,_}) -> z end)
    {_,_,_,min_w} = Enum.min_by(cells, fn({_,_,_,w}) -> w end)
    {_,_,_,max_w} = Enum.max_by(cells, fn({_,_,_,w}) -> w end)

    {min_x-1, max_x+1, min_y-1, max_y+1, min_z-1, max_z+1, min_w-1, max_w+1}
  end

end

Solution1.solve(input)
Solution2.solve(input)
