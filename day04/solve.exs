[file] = System.argv

input = File.read!(file) 
        |> String.split("\n\n") 

defmodule Solution1 do
  def solve(input) do
    valids = Enum.map(input, &parse/1) |> Enum.filter(&valid/1)
    IO.puts(length(valids))
  end

  def parse(passport) do
    String.replace(passport, "\n", " ") 
    |> String.split(" ", trim: true) 
    |> Enum.map(fn x -> String.split(x, ":") end) 
    |> Enum.reduce(%{},fn [key, value], acc -> Map.put(acc, key, value) end)
  end

  def valid(passport) do
    ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"] |> Enum.all?(&(Map.has_key?(passport, &1)))
  end
end

defmodule Solution2 do
  def solve(input) do
    valids = Enum.map(input, &parse/1) |> Enum.filter(&valid/1) |> Enum.filter(&valid_2/1)
    IO.puts(length(valids))
  end

  def valid(passport) do
    ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"] |> Enum.all?(&(Map.has_key?(passport, &1)))
  end

  def valid_2(passport) do
    Enum.all?(passport, fn ({key, value}) -> valid_key(key, value) end)
  end

  def valid_key("byr",value) do
    byr = String.to_integer(value)
    byr >= 1920 and byr <= 2002
  end
  def valid_key("iyr",value) do
    byr = String.to_integer(value)
    byr >= 2010 and byr <= 2020
  end
  def valid_key("eyr",value) do
    byr = String.to_integer(value)
    byr >= 2020 and byr <= 2030
  end
  def valid_key("hgt",value) do
    {height, unit} = String.split_at(value, String.length(value)-2)
    height = try do
      String.to_integer(height)
    rescue
      _ -> 0
    end
    case unit do
      "cm" -> 
        height >= 150 and height <= 193
      "in" -> 
        height >= 59 and height <= 76
      _ -> 
        false
    end
  end
  def valid_key("hcl",value) do
    Regex.match?(~r/#[0-9a-f]{6}/, value) and String.length(value) == 7
  end
  def valid_key("ecl",value) do
    Regex.match?(~r/(amb|blu|brn|gry|grn|hzl|oth)/, value) and String.length(value) == 3
  end
  def valid_key("pid",value) do
    Regex.match?(~r/[0-9]{9}/, value) and String.length(value) == 9
  end

  def valid_key(_, _), do: true

  def parse(passport) do
    String.replace(passport, "\n", " ") 
    |> String.split(" ", trim: true) 
    |> Enum.map(fn x -> String.split(x, ":") end) 
    |> Enum.reduce(%{},fn [key, value], acc -> Map.put(acc, key, value) end)
  end
end


Solution1.solve(input)
Solution2.solve(input)
