defmodule Solver do
  def solve(a, b, {target_x, target_y}) do
    dividend = b.xinc * target_y - b.yinc * target_x
    divisor = b.xinc * a.yinc - b.yinc * a.xinc

    if rem(dividend, divisor) == 0 do
      a_press = div(dividend, divisor)
      b_press = div(target_y - a_press * a.yinc, b.yinc)
      {a_press, b_press}
    else
      nil
    end
  end

  def parse_button(button) do
    [_, button] = String.split(button, ": ")

    [xinc, yinc] =
      String.split(button, ", ")
      |> Enum.map(fn inc ->
        [_, num] = String.split(inc, "+")
        String.to_integer(num)
      end)

    {xinc, yinc}
  end

  def parse_prize(prize) do
    [_, prize] = String.split(prize, ": ")

    [xinc, yinc] =
      String.split(prize, ", ")
      |> Enum.map(fn inc ->
        [_, num] = String.split(inc, "=")
        String.to_integer(num)
      end)

    {xinc, yinc}
  end
end

{:ok, content} = File.read("data/day13.txt")

machines =
  content
  |> String.split("\n")
  |> Enum.chunk_every(4)
  |> Enum.map(fn [button_a, button_b, prize, _] ->
    {xinc_a, yinc_a} = Solver.parse_button(button_a)
    {xinc_b, yinc_b} = Solver.parse_button(button_b)
    {x, y} = Solver.parse_prize(prize)

    {
      %{xinc: xinc_a, yinc: yinc_a, cost: 3},
      %{xinc: xinc_b, yinc: yinc_b, cost: 1},
      {x, y}
    }
  end)

cost =
  Enum.map(
    machines,
    fn {btn_a, btn_b, {target_x, target_y}} ->
      Solver.solve(
        btn_a,
        btn_b,
        {target_x + 10_000_000_000_000, target_y + 10_000_000_000_000}
      )
    end
  )
  |> Enum.filter(fn res -> res != nil end)
  |> Enum.map(fn {a, b} -> 3 * a + b end)
  |> Enum.sum()

IO.inspect(cost)
