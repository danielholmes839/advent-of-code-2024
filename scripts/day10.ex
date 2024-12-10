{:ok, contents} = File.read("data/day10.txt")

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
  |> Enum.reduce(%{}, fn {char, i, j}, grid -> Map.put(grid, {i, j}, String.to_integer(char)) end)

edges =
  grid
  |> Enum.map(fn {{x, y} = origin_pos, _} ->
    origin_val = Map.get(grid, {x, y})

    [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
    |> Enum.map(fn {dx, dy} ->
      {x + dx, y + dy}
    end)
    |> Enum.filter(fn neighbour_pos -> Map.get(grid, neighbour_pos) == origin_val + 1 end)
    |> Enum.map(fn neighbour_pos -> {origin_pos, neighbour_pos} end)
  end)
  |> List.flatten()

edge_map =
  Enum.reduce(edges, %{}, fn {origin, neighbour}, g ->
    case Map.get(g, origin) do
      nil -> Map.put(g, origin, [neighbour])
      neighbours -> Map.put(g, origin, [neighbour | neighbours])
    end
  end)

# IO.inspect(edge_map)

defmodule Explore do
  def distinct(grid, edge_map, origin) do
    num = Map.get(grid, origin)

    cond do
      num == 9 ->
        1

      true ->
        Map.get(edge_map, origin, [])
        |> Enum.map(fn neighbour ->
          distinct(grid, edge_map, neighbour)
        end)
        |> Enum.sum()
    end
  end
end

sum =
  grid
  |> Enum.filter(fn {_position, val} -> val == 0 end)
  |> Enum.map(fn {position, _} ->
    Explore.distinct(grid, edge_map, position)
  end)
  |> Enum.sum()

# IO.inspect(:digraph_utils.reachable([{0, 0}], g))
IO.inspect(sum)
