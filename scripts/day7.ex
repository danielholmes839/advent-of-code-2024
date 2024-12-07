{:ok, contents} = File.read("data/day7.txt")

equations =
  contents
  |> String.split("\n")
  |> Enum.map(fn line ->
    [result | operands] =
      line
      |> String.replace(":", "")
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    {result, operands}
  end)

defmodule Solver do
  def solve({result, [operand | remaining_operands]}) do
    solve({result, remaining_operands}, operand)
  end

  def solve({result, [operand | remaining_operands]}, acc) do
    if acc > result do
      false
    else
      solve({result, remaining_operands}, acc * operand) or
        solve({result, remaining_operands}, acc + operand)
    end
  end

  def solve({result, []}, acc) do
    acc == result
  end
end

IO.inspect(
  equations
  |> Enum.filter(&Solver.solve/1)
  |> Enum.map(fn {result, _} -> result end)
  |> Enum.sum()
)
