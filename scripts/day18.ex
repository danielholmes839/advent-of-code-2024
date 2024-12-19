defmodule Day18 do
  def part1(grid_corrupted, start, target) do
    visited = bfs(grid_corrupted, %{}, [start], 0)
    Map.get(visited, target)
  end

  def bfs(grid_corrupted, visited, queue, depth) do
    {new_queue, new_visited} =
      Enum.reduce(queue, {MapSet.new(), visited}, fn position, {new_queue, visited} ->
        visited = Map.put(visited, position, depth)
        positions = neighbours(grid_corrupted, visited, position)

        new_queue =
          Enum.reduce(positions, new_queue, fn position, q -> MapSet.put(q, position) end)

        {new_queue, visited}
      end)

    if MapSet.size(new_queue) > 0 do
      bfs(grid_corrupted, new_visited, new_queue, depth + 1)
    else
      new_visited
    end
  end

  def neighbours(grid_corrupted, visited, {x, y}) do
    [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.filter(fn position ->
      cond do
        Map.has_key?(visited, position) -> false
        Map.get(grid_corrupted, position) == true -> false
        Map.get(grid_corrupted, position) == nil -> false
        true -> true
      end
    end)
  end
end

{:ok, contents} = File.read("data/day18.txt")

bytes =
  contents
  |> String.split("\n")
  |> Enum.map(fn line ->
    [left, right] = String.split(line, ",")
    {String.to_integer(left), String.to_integer(right)}
  end)

Enum.each(2000..4000, fn i ->
  size = 70
  start = {0, 0}
  target = {size, size}
  bytes_count = i

  grid =
    for(
      x <- 0..size,
      y <- 0..size,
      do: {{x, y}, false}
    )
    |> Enum.into(%{})

  corrupted =
    bytes
    |> Enum.slice(0..(bytes_count - 1))

  grid_corrupted =
    Enum.reduce(corrupted, grid, fn position, acc ->
      Map.put(acc, position, true)
    end)

  depth = Day18.part1(grid_corrupted, start, target)

  if depth == nil do
    [position | _] = Enum.reverse(corrupted)
    exit({position, bytes_count})
  end
end)
