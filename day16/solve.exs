[file] = System.argv

input = File.read!(file) 
        |> String.split("\n\n", trim: true) 

defmodule Solution1 do
  def solve(input) do
    ranges = Enum.at(input, 0) 
             |> String.split("\n", trim: true) 
             |> Enum.map(fn(x) -> 
               x = Enum.at(String.split(x, ":", trim: true), 1)
               {first, _, second} = List.to_tuple(String.split(x, " ", trim: true))
               a = String.split(first, "-") |> Enum.map(&String.to_integer/1)
               b = String.split(second, "-") |> Enum.map(&String.to_integer/1)
               {a,b}
             end) 
    _your_ticket = Enum.at(input, 1) 
                  |> String.split("\n", trim: true) 
                  |> List.delete_at(0)
                  |> Enum.at(0)
                  |> String.split(",", trim: true)
                  |> Enum.map(&String.to_integer/1)
    tickets = Enum.at(input, 2) 
              |> String.split("\n", trim: true)
              |> List.delete_at(0)
              |> Enum.map(&String.split(&1, ",", trim: true) 
                          |> Enum.map(fn(x) -> String.to_integer(x) end))
              |> List.flatten
    IO.inspect Enum.filter(tickets, fn(x) -> 
      a = Enum.filter(ranges, fn({[min1, max1], [min2, max2]}) -> 
        x in min1..max1 or x in min2..max2
      end)
      length(a) == 0
    end) |> Enum.sum
  end
end

defmodule Solution2 do
  def solve(input) do
    ranges = Enum.at(input, 0) 
             |> String.split("\n", trim: true) 
             |> Enum.map(fn(x) -> 
               x = Enum.at(String.split(x, ":", trim: true), 1)
               {first, _, second} = List.to_tuple(String.split(x, " ", trim: true))
               a = String.split(first, "-") |> Enum.map(&String.to_integer/1)
               b = String.split(second, "-") |> Enum.map(&String.to_integer/1)
               {a,b}
             end) 

    your_ticket = Enum.at(input, 1) 
                  |> String.split("\n", trim: true) 
                  |> List.delete_at(0)
                  |> Enum.at(0)
                  |> String.split(",", trim: true)
                  |> Enum.map(&String.to_integer/1)

    tickets = Enum.at(input, 2) 
              |> String.split("\n", trim: true)
              |> List.delete_at(0)
              |> Enum.map(&String.split(&1, ",", trim: true) 
                          |> Enum.map(fn(x) -> String.to_integer(x) end))

    valid_tickets = Enum.filter(tickets, fn(ticket) -> 
                      a = Enum.filter(ticket, fn(y) -> 
                        a = Enum.filter(ranges, fn({[min1, max1], [min2, max2]}) -> 
                          y in min1..max1 or y in min2..max2
                        end)
                        length(a) == 0
                      end)
                      length(a) == 0
                    end)

    columns = Enum.map(0..length(Enum.at(valid_tickets,0))-1, fn(index) ->
      Enum.map(valid_tickets, fn(t) -> 
        Enum.at(t, index)
      end) 
    end)

    limits = Enum.map(ranges, fn({[min1, max1], [min2, max2]}) -> 
      Enum.filter(0..length(columns)-1, fn(index) -> 
        column = Enum.at(columns, index)
        # all ticket values should be inside the range
        b = Enum.all?(column, fn(v) -> 
          v in min1..max1 or v in min2..max2 
        end)
        b
      end)
    end)

    fixed = fix(limits, %{})

    IO.inspect Enum.reduce(0..5, 1, fn(x, acc) -> 
      dep_value = Enum.at(your_ticket, fixed[x]) 
      acc * dep_value
    end)
  end

  def fix(limits, fixed) do
    [{[limited], index}] = Enum.with_index(limits) |> Enum.filter(fn({e,_}) -> length(e) == 1 end)
    fixed = Map.put(fixed, index, limited)
    limits = Enum.map(limits, fn(x) -> List.delete(x, limited) end)
    max = Enum.map(limits, &length/1) |> Enum.max
    case max do
      0 -> fixed
      _ -> fix(limits, fixed)
    end
  end
end

Solution1.solve(input)
Solution2.solve(input)
