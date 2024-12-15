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
  |> String.replace("#", "##")
  |> String.replace("O", "[]")
  |> String.replace(".", "..")
  |> String.replace("@", "@.")
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
    |> Enum.filter(fn {_, char} -> char == "[" end)
    |> Enum.map(fn {{x, y}, _} -> y * 100 + x end)
    |> Enum.sum()
  end

  def get_moves(grid, false, {x, y} = pos, {dx, dy} = dir) do
    false
  end

  def get_moves(grid, moves, {x, y}, {dx, dy} = dir) do
    char = Map.get(grid, {x, y})

    if Map.has_key?(moves, {x, y}) do
      moves
    else
      case {char, dy} do
        {"@", _} ->
          moves = Map.put(moves, {x, y}, char)
          get_moves(grid, moves, {x + dx, y + dy}, dir)

        {"#", _} ->
          false

        {".", _} ->
          moves

        {"[", 0} ->
          moves = Map.put(moves, {x, y}, char)
          get_moves(grid, moves, {x + dx, y + dy}, dir)

        {"]", 0} ->
          moves = Map.put(moves, {x, y}, char)
          get_moves(grid, moves, {x + dx, y + dy}, dir)

        {"[", _} ->
          moves = Map.put(moves, {x, y}, char)
          moves = get_moves(grid, moves, {x + dx, y + dy}, dir)
          moves = get_moves(grid, moves, {x + 1, y}, dir)
          moves

        {"]", _} ->
          moves = Map.put(moves, {x, y}, char)
          moves = get_moves(grid, moves, {x + dx, y + dy}, dir)
          moves = get_moves(grid, moves, {x - 1, y}, dir)
          moves
      end
    end
  end

  def reduce_move({dx, dy} = direction, {grid, {x, y} = robot}) do
    case get_moves(grid, %{}, robot, direction) do
      false ->
        {grid, robot}

      moves ->
        # IO.puts("--------------")
        # IO.inspect(moves)

        # IO.inspect(
        #   Enum.group_by(grid, fn {_, k} -> k end)
        #   |> Enum.map(fn {k, arr} -> {k, length(arr)} end)
        #   |> Enum.into(%{})
        # )

        grid =
          Enum.reduce(moves, grid, fn {{x, y}, char}, acc ->
            acc = Map.put(acc, {x + dx, y + dy}, char)
            prev = Map.get(moves, {x - dx, y - dy})

            cond do
              prev == nil ->
                Map.put(acc, {x, y}, ".")

              true ->
                Map.put(acc, {x, y}, prev)
            end
          end)

        {grid, {x + dx, y + dy}}
    end
  end
end

IO.inspect(Day15.solve(grid, moves))
