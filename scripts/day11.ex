stones =
  "5 62914 65 972 0 805922 6521 1639064"
  |> String.split(" ")
  |> Enum.map(&String.to_integer/1)

defmodule Stones do
  def blink_many(stones, n) do
    Enum.reduce(1..n, stones, fn i, curr ->
      IO.puts(i)

      Enum.reduce(curr, [], fn stone, new_stones ->
        case blink(stone) do
          {left_val, right_val} -> [right_val, left_val | new_stones]
          new_val -> [new_val | new_stones]
        end
      end)
      |> Enum.reverse()
    end)
  end

  def blink(stone) do
    cond do
      stone == 0 ->
        1

      rem(digits(stone, 0), 2) == 0 ->
        split(stone)

      true ->
        stone * 2024
    end
  end

  defp digits(stone, acc) do
    if stone == 0 do
      max(acc, 1)
    else
      quotient = div(stone, 10)
      digits(quotient, acc + 1)
    end
  end

  defp split(stone) do
    d = digits(stone, 0)
    divisor = 10 ** div(d, 2)
    {div(stone, divisor), rem(stone, divisor)}
  end
end

# IO.inspect([1001, 1000, 999, 100, 99, 1, 0] |> Enum.map(fn stone -> Stones.blink(stone) end))

IO.inspect(Stones.blink_many(stones, 75) |> Enum.count())
