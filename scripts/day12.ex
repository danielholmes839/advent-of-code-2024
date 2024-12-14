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

  def edges(region) do
    region_map = region |> Enum.map(fn position -> {position, true} end) |> Enum.into(%{})

    region_by_edge =
      [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
      |> Enum.map(fn {dx, dy} ->
        {{dx, dy},
         region |> Enum.filter(fn {x, y} -> !Map.has_key?(region_map, {x + dx, y + dy}) end)}
      end)

    region_by_edge
    |> Enum.map(fn {_, positions} ->
      edge_groups(positions)
    end)
    |> Enum.sum()
  end

  def edge_groups(positions) do
    positions_map = positions |> Enum.map(fn position -> {position, true} end) |> Enum.into(%{})

    directions = [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]

    g = :digraph.new()

    positions |> Enum.each(fn position -> :digraph.add_vertex(g, position) end)

    positions
    |> Enum.each(fn {x, y} ->
      Enum.each(directions, fn {dx, dy} ->
        if Map.has_key?(positions_map, {x + dx, y + dy}) do
          :digraph.add_edge(g, {x, y}, {x + dx, y + dy})
        end
      end)
    end)

    length(:digraph_utils.strong_components(g))

    # {_, acc} =
    #   Enum.reduce(positions, {positions_map, 0}, fn position, {remaining, acc} ->
    #     if !Map.has_key?(remaining, position) do
    #       {remaining, acc}
    #     else
    #       remaining = explore_edge(position, remaining)
    #       {remaining, acc + 1}
    #     end
    #   end)

    # acc
  end

  # def explore_edge(position, remaining) do
  #   remaining = Enum.reduce_while()
  # end

  # def fence(grid, {x, y}) do
  #   plant = Map.get(grid, {x, y})

  #   [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
  #   |> Enum.map(fn {dx, dy} ->
  #     neighbour_plant = Map.get(grid, {x + dx, y + dy})

  #     cond do
  #       neighbour_plant == plant ->
  #         0

  #       true ->
  #         1
  #     end
  #   end)
  #   |> Enum.sum()
  # end
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
  |> Enum.map(fn {_, region} ->
    edges = Measure.edges(region)
    area = length(region)
    area * edges
  end)
  |> Enum.sum()

IO.puts(sum)
