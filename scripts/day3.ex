{:ok, content} = File.read("./data/day3.txt")

findMulExpr = ~r"mul\(\d+,\d+\)"
findDoExpr = ~r"do\(\)"
findDontExpr = ~r"don't\(\)"
findNumExpr = ~r"\d+"

sum =
  Regex.scan(findMulExpr, content)
  |> Enum.map(fn [match] ->
    [[left], [right]] = Regex.scan(findNumExpr, match)
    {String.to_integer(left), String.to_integer(right)}
  end)
  |> Enum.filter(fn {left, right} ->
    left < 1000 and right < 1000
  end)
  |> Enum.map(fn {left, right} -> left * right end)
  |> Enum.sum()

IO.puts(sum)

# PART 2
mulOps =
  Regex.scan(findMulExpr, content, return: :index)
  |> Enum.map(fn [{i, len}] ->
    match = String.slice(content, i..(i + len - 1))
    [[left], [right]] = Regex.scan(findNumExpr, match)
    {i, String.to_integer(left), String.to_integer(right)}
  end)
  |> Enum.filter(fn {_, left, right} ->
    left < 1000 and right < 1000
  end)
  |> Enum.map(fn {i, left, right} -> {i, left * right} end)

dontOps =
  Regex.scan(findDontExpr, content, return: :index)
  |> Enum.map(fn [{i, _}] ->
    {i, :dont}
  end)

doOps =
  Regex.scan(findDoExpr, content, return: :index)
  |> Enum.map(fn [{i, _}] -> {i, :do} end)

defmodule Mul do
  def reduce(:dont, {sum, _}) do
    {sum, :dont}
  end

  def reduce(:do, {sum, _}) do
    {sum, :do}
  end

  def reduce(num, {sum, mode}) do
    case mode do
      :do -> {sum + num, mode}
      :dont -> {sum, mode}
    end
  end
end

{sum, _} =
  Enum.sort(mulOps ++ dontOps ++ doOps, fn {l, _}, {r, _} -> r > l end)
  |> Enum.map(fn {_, op} -> op end)
  |> Enum.reduce({0, :do}, &Mul.reduce/2)

IO.inspect(sum)
