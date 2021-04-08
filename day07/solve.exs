[file] = System.argv

input = File.read!(file) 
        |> String.split("\n", trim: true) 

defmodule Solution1 do
  def solve(input) do
    abc = input |> Enum.map(&parse/1)
    IO.inspect length(can_hold(abc, "shinygold"))
  end

  def can_hold(bags, color) do
    a = Enum.filter(bags, fn([_filter_color, contains]) ->
      contained = Enum.filter(contains, fn([contained_color, _quantity]) ->
        color == contained_color
      end)
      length(contained) != 0
    end) |> Enum.map(fn([c,_]) -> c end)
    b = Enum.map(a, fn(c) ->
      can_hold(bags, c)
    end) |> List.flatten


    Enum.concat(a,b) |> Enum.uniq
  end

  def parse(line) do
    #vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    #faded blue bags contain no other bags.
    [adjective, color, _bag, _contains | rest] = String.split(line, " ")
    bag = adjective <> color
    abc = parse_rest(rest)
    [bag, abc]
  end

  def parse_rest([first, _rest]) when first == "no" do [] end
  def parse_rest([number, adjective, color, _bags | rest]) do
    a = [[adjective<>color, number]]
    b = parse_rest(rest)
    case b do
      nil ->
        a
      _ ->
        Enum.concat(a,b)
    end
  end
  def parse_rest(_) do [] end
end

defmodule Solution2 do
  def solve(input) do
    abc = input |> Enum.map(&parse/1)
    IO.inspect can_hold(abc, "shinygold")
  end

  def can_hold(bags, color) do
    [[_, contains]]= Enum.filter(bags, fn([c,_]) -> c == color end )

    case contains do
      [] ->
        0
      _ ->
        Enum.map(contains, fn([c,q]) -> q + q * can_hold(bags, c) end) |> Enum.sum
    end
  end

  def parse(line) do
    #vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    #faded blue bags contain no other bags.
    [adjective, color, _bag, _contains | rest] = String.split(line, " ")
    bag = adjective <> color
    abc = parse_rest(rest)
    [bag, abc]
  end

  def parse_rest([first, _rest]) when first == "no" do [] end
  def parse_rest([number, adjective, color, _bags | rest]) do
    a = [[adjective<>color, String.to_integer(number)]]
    b = parse_rest(rest)
    case b do
      nil ->
        a
      _ ->
        Enum.concat(a,b)
    end
  end
  def parse_rest(_) do [] end

end


Solution1.solve(input)
Solution2.solve(input)
