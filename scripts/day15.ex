{:ok, contents} = File.read("data/day15.txt")

[grid, moves] = contents |> String.split("\n\n")

directions = %{
  ">" => {1, 0},
  "<" => {-1, 0},
  "v" => {0, 1},
  "^" => {0, -1}
}

grid =
  grid
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

moves =
  moves
  |> String.replace("\n", "")
  |> String.graphemes()
  |> Enum.map(fn move -> Map.get(directions, move) end)

defmodule Day15 do
  def solve(grid, moves) do
    {robot, _} = Enum.find(grid, fn {_, val} -> val == "@" end)

    {grid, _} =
      Enum.reduce(moves, {grid, robot}, &reduce_move/2)

    grid
    |> Enum.filter(fn {_, char} -> char == "O" end)
    |> Enum.map(fn {{x, y}, _} -> y * 100 + x end)
    |> Enum.sum()
  end

  def move?(grid, {x, y}, {dx, dy}) do
    case Map.get(grid, {x, y}) do
      "@" -> move?(grid, {x + dx, y + dy}, {dx, dy})
      "O" -> move?(grid, {x + dx, y + dy}, {dx, dy})
      "." -> true
      "#" -> false
    end
  end

  def reduce_move({dx, dy} = direction, {grid, {x, y} = robot}) do
    if move?(grid, robot, direction) do
      grid = move(grid, robot, direction, ".")
      {grid, {x + dx, y + dy}}
    else
      # can't move
      {grid, robot}
    end
  end

  def move(grid, {x, y}, {dx, dy}, replace_char) do
    char = Map.get(grid, {x, y})
    grid = Map.put(grid, {x, y}, replace_char)

    if char == "." do
      grid
    else
      move(grid, {x + dx, y + dy}, {dx, dy}, char)
    end
  end
end

IO.inspect(Day15.solve(grid, moves))
