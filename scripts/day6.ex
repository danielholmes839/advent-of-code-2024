{:ok, contents} = File.read("data/day6.txt")

defmodule Explore do
  def explore(grid, explored, {x, y} = position, direction) do
    if Map.has_key?(explored, {x, y, direction}) do
      true
    else
      explored = Map.put(explored, {x, y, direction}, true)

      directions = %{up: {0, -1}, right: {1, 0}, down: {0, 1}, left: {-1, 0}}
      transitions = %{up: :right, right: :down, down: :left, left: :up}

      {dx, dy} = Map.get(directions, direction)
      new_position = {x + dx, y + dy}
      new_position_char = Map.get(grid, new_position)

      case new_position_char do
        nil ->
          # reached the end of the grid
          false

        "#" ->
          # hit wall. explore the same position but new direction
          new_direction = Map.get(transitions, direction)
          explore(grid, explored, position, new_direction)

        _ ->
          # walk in current direction
          explore(grid, explored, new_position, direction)
      end
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
  grid
  |> Map.keys()
  |> Enum.filter(fn pos -> pos != pos_start end)
  |> Enum.filter(fn pos -> Map.get(grid, pos) == "." end)
  |> Task.async_stream(
    fn pos ->
      new_grid = Map.put(grid, pos, "#")
      has_loop = Explore.explore(new_grid, %{}, pos_start, :up)
      has_loop
    end,
    # concurrency hell yeah
    max_concurrency: 8
  )
  |> Enum.filter(fn
    {:ok, true} -> true
    _ -> false
  end)
  |> Enum.count()

IO.inspect(unique)
