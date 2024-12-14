defmodule Solver do
  def solve(combinations, a, b, {target_x, target_y}) do
    combinations
    |> Enum.map(fn {a_click, b_click} ->
      x = a.xinc * a_click + b.xinc * b_click
      y = a.yinc * a_click + b.yinc * b_click
      cost = a.cost * a_click + b.cost * b_click

      {x, y, cost}
    end)
    |> Enum.filter(fn {x, y, _} -> x == target_x and y == target_y end)
    |> Enum.map(fn {_, _, cost} -> cost end)
    |> Enum.min(fn -> 0 end)
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

combinations =
  Enum.map(0..100, fn a_click ->
    Enum.map(0..100, fn b_click -> {a_click, b_click} end)
  end)
  |> List.flatten()

# IO.inspect(machines)

cost =
  Enum.map(machines, fn {button_a, button_b, target} ->
    Solver.solve(
      combinations,
      button_a,
      button_b,
      target
    )
  end)
  |> Enum.sum()

IO.inspect(cost)
