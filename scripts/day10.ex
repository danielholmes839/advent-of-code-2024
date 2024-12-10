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

g = :digraph.new()

Enum.each(grid, fn {position, num} ->
  :digraph.add_vertex(g, position, num)
end)

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

edges
|> Enum.each(fn {origin_pos, neighbour_pos} -> :digraph.add_edge(g, origin_pos, neighbour_pos) end)

# IO.inspect(edges |> Enum.map(fn {a, b} -> {Map.get(grid, a), Map.get(grid, b)} end))

sum =
  grid
  |> Enum.filter(fn {_position, val} -> val == 0 end)
  |> Enum.map(fn {position, _} ->
    :digraph_utils.reachable([position], g)
    |> Enum.filter(fn position -> Map.get(grid, position) == 9 end)
    |> Enum.count()
  end)
  |> Enum.sum()

IO.inspect(:digraph_utils.reachable([{0, 0}], g))
IO.inspect(sum)
