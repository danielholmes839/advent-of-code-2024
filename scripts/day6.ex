{:ok, contents} = File.read("data/day6.txt")

defmodule Explore do
  def explore(%{} = explored, map, {x, y} = position, direction) do
    directions = %{up: {0, -1}, right: {1, 0}, down: {0, 1}, left: {-1, 0}}
    transitions = %{up: :right, right: :down, down: :left, left: :up}

    if Map.has_key?(explored, {x, y, direction}) or Map.get(map, position) == nil do
      explored
    else
      {dx, dy} = Map.get(directions, direction)
      explored = Map.put(explored, {x, y, direction}, true)

      new_direction =
        case Map.get(map, {x + dx, y + dy}) do
          "#" ->
            Map.get(transitions, direction)

          _ ->
            direction
        end

      {dx, dy} = Map.get(directions, new_direction)
      new_position = {x + dx, y + dy}

      explore(explored, map, new_position, new_direction)
    end
  end
end

map =
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
  |> Enum.reduce(%{}, fn {char, i, j}, map -> Map.put(map, {i, j}, char) end)

{pos_start, _} = Enum.find(map, fn {_, val} -> val == "^" end)

unique =
  Explore.explore(%{}, map, pos_start, :up)
  |> Map.keys()
  |> Enum.map(fn {x, y, _} -> {x, y} end)
  |> Enum.uniq()

IO.inspect(length(unique))

# IO.inspect(map)
# IO.inspect(start)
# IO.inspect(directions)
# IO.inspect(transitions)
