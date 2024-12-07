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
  def solve({target, [operand | remaining_operands]}) do
    # set the first operand as the acc
    solve({target, remaining_operands}, operand)
  end

  def solve({target, []}, acc) do
    # empty operands so check the acc
    acc == target
  end

  def solve({target, [operand | remaining_operands]}, acc) do
    if acc > target do
      false
    else
      solve({target, remaining_operands}, acc * operand) or
        solve({target, remaining_operands}, acc + operand) or
        solve({target, remaining_operands}, concat(acc, operand))
    end
  end

  def concat(target, acc) do
    str = Integer.to_string(target) <> Integer.to_string(acc)
    String.to_integer(str)
  end
end

IO.inspect(
  equations
  |> Enum.filter(&Solver.solve/1)
  |> Enum.map(fn {result, _} -> result end)
  |> Enum.sum()
)

# part 1 solution: 14711933466277
# part 2 solution: 286580387663654
