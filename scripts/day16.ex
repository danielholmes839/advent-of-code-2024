{:ok, contents} = File.read("data/day16_example.txt")

grid =
  contents
  |> String.split("\n")
  |> Enum.with_index()
  |> Enum.map(fn {line, lineNum} ->
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {char, charNum} -> {char, charNum, lineNum} end)
  end)
  |> List.flatten()
  |> Enum.reduce(%{}, fn {char, i, j}, grid -> Map.put(grid, {i, j}, char) end)

defmodule Day16 do
  def part1(grid) do
    {start, _} = Enum.find(grid, fn {_, char} -> char == "S" end)
    {target, _} = Enum.find(grid, fn {_, char} -> char == "E" end)

    east = {1, 0}
    costs = explore(grid, %{}, start, east, 0)

    [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]
    |> Enum.map(fn direction -> Map.get(costs, {target, direction}) end)
    |> Enum.min()
  end

  def explore(grid, costs, {x, y} = position, {dx, dy} = direction, cost) do
    cw_rotations = %{
      # right > down
      {1, 0} => {0, 1},
      # down > left
      {0, 1} => {-1, 0},
      # left > up
      {-1, 0} => {0, -1},
      # up > right
      {0, -1} => {1, 0}
    }

    ccw_rotations = %{
      # down > right
      {0, 1} => {1, 0},
      # left > down
      {-1, 0} => {0, 1},
      # up > left
      {0, -1} => {-1, 0},
      # right > up
      {1, 0} => {0, -1}
    }

    if Map.get(grid, position) == "#" or Map.get(costs, {position, direction}) <= cost do
      costs
    else
      costs = Map.put(costs, {position, direction}, cost)
      costs = explore(grid, costs, {x + dx, y + dy}, direction, cost + 1)
      costs = explore(grid, costs, position, Map.get(ccw_rotations, direction), cost + 1000)
      costs = explore(grid, costs, position, Map.get(cw_rotations, direction), cost + 1000)
      costs
    end
  end
end

cost = Day16.part1(grid)
IO.puts(cost)
