{:ok, contents} = File.read("./data/day4.txt")

characters =
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

defmodule Search do
  def search_p2(grid, {x, y}) do
    vectors = [{-1, -1}, {1, 1}, {-1, 1}, {1, -1}]

    [d11, d12, d21, d22] =
      Enum.map(vectors, fn {i, j} -> Search.search(grid, "MAS", {x - i, y - j}, {i, j}) end)

    if d11 + d12 > 0 and d21 + d22 > 0 do
      1
    else
      0
    end
  end

  def search(grid, target, pos) do
    directions = [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}]

    directions
    |> Enum.map(fn direction -> search(grid, target, pos, direction) end)
    |> Enum.sum()
  end

  def search(_grid, "", _pos, _dir) do
    1
  end

  def search(grid, target, {x, y} = pos, {i, j} = dir) do
    char = Map.get(grid, pos)
    targetFirstChar = String.first(target)

    cond do
      targetFirstChar == char ->
        search(grid, String.slice(target, 1..-1//1), {x + i, y + j}, dir)

      true ->
        0
    end
  end
end

sum =
  characters
  |> Enum.map(fn {pos, _} -> Search.search(characters, "XMAS", pos) end)
  |> Enum.sum()

IO.puts(sum)

sum =
  characters
  |> Enum.map(fn {pos, _} -> Search.search_p2(characters, pos) end)
  |> Enum.sum()

IO.puts(sum)
