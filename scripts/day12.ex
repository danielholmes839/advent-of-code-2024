{:ok, contents} = File.read("data/day12.txt")

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

defmodule Measure do
  def explore(grid, seen, region, {x, y}) do
    # IO.inspect({map_size(region), x, y})

    if Map.has_key?(seen, {x, y}) do
      {seen, region}
    else
      plant = Map.get(grid, {x, y})
      seen = Map.put(seen, {x, y}, true)
      region = Map.put(region, {x, y}, true)

      [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.filter(fn {nx, ny} -> Map.get(grid, {nx, ny}) == plant end)
      |> Enum.reduce({seen, region}, fn {nx, ny}, {new_seen, new_region} ->
        explore(grid, new_seen, new_region, {nx, ny})
      end)
    end
  end

  def fence(grid, {x, y}) do
    plant = Map.get(grid, {x, y})

    [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
    |> Enum.map(fn {dx, dy} ->
      neighbour_plant = Map.get(grid, {x + dx, y + dy})

      cond do
        neighbour_plant == plant ->
          0

        true ->
          1
      end
    end)
    |> Enum.sum()
  end
end

{_, regions} =
  grid
  |> Enum.reduce({%{}, []}, fn {{x, y}, plant}, {seen, regions} ->
    if Map.has_key?(seen, {x, y}) do
      {seen, regions}
    else
      {seen, region} = Measure.explore(grid, seen, %{}, {x, y})

      {seen, [{plant, Map.keys(region)} | regions]}
    end
  end)

sum =
  regions
  |> Enum.map(fn {_, positions} ->
    perimeter =
      positions |> Enum.map(fn position -> Measure.fence(grid, position) end) |> Enum.sum()

    area = length(positions)
    area * perimeter
  end)
  |> Enum.sum()

IO.puts(sum)
