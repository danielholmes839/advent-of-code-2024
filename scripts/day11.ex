stones =
  "5 62914 65 972 0 805922 6521 1639064"
  |> String.split(" ")
  |> Enum.map(&String.to_integer/1)

defmodule Stones do
  def blink_many(stones, depth) do
    stones
    |> Enum.map(fn stone ->
      {n, _} = blink(%{}, stone, depth)
      n
    end)
    |> Enum.sum()
  end

  def blink(table, stone, depth) do
    cond do
      Map.has_key?(table, {stone, depth}) ->
        {Map.get(table, {stone, depth}), table}

      depth == 0 ->
        {1, table}

      stone == 0 ->
        {n, table} = blink(table, 1, depth - 1)
        {n, Map.put(table, {stone, depth}, n)}

      rem(digits(stone), 2) == 0 ->
        {left_stone, right_stone} = split(stone)
        {ln, table} = blink(table, left_stone, depth - 1)
        {rn, table} = blink(table, right_stone, depth - 1)
        {ln + rn, Map.put(table, {stone, depth}, ln + rn)}

      true ->
        {n, table} = blink(table, stone * 2024, depth - 1)
        {n, Map.put(table, {stone, depth}, n)}
    end
  end

  defp digits(stone) do
    Integer.to_charlist(stone) |> length
  end

  defp split(stone) do
    d = digits(stone)
    divisor = 10 ** div(d, 2)
    {div(stone, divisor), rem(stone, divisor)}
  end
end

IO.inspect(Stones.blink_many(stones, 25))
