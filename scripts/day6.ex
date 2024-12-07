{:ok, contents} = File.read("data/day6.txt")

defmodule Explore do
  def explore(%{} = explored, grid, {x, y} = position, direction) do
    directions = %{up: {0, -1}, right: {1, 0}, down: {0, 1}, left: {-1, 0}}
    transitions = %{up: :right, right: :down, down: :left, left: :up}

    explored = Map.put(explored, {x, y, direction}, true)
    {dx, dy} = Map.get(directions, direction)

    new_position = {x + dx, y + dy}

    case Map.get(grid, new_position) do
      nil ->
        # reached the end of the grid
        explored

      "#" ->
        # hit wall. explore the same position but new direction
        new_direction = Map.get(transitions, direction)
        explore(explored, grid, position, new_direction)

      _ ->
        # walk in current direction
        explore(explored, grid, new_position, direction)
    end
  end
end

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

{pos_start, _} = Enum.find(grid, fn {_, val} -> val == "^" end)

unique =
  Explore.explore(%{}, grid, pos_start, :up)
  |> Map.keys()
  |> Enum.map(fn {x, y, _} -> {x, y} end)
  |> Enum.uniq()

IO.inspect(length(unique))
