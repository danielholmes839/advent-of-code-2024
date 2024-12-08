{:ok, contents} = File.read("data/day8.txt")

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

defmodule Antenna do
  def resonant_positions(grid, {x1, y1}, {x2, y2}) do
    {dx, dy} = {x2 - x1, y2 - y1}
    gcd = GCD.gcd(dx, dy)
    {dx, dy} = {div(dx, gcd), div(dy, gcd)}

    positions = iter(grid, {x1, y1}, {dx, dy}, []) ++ iter(grid, {x1, y1}, {-dx, -dy}, [])
    positions
  end

  def iter(grid, {x, y} = pos, {dx, dy}, acc) do
    if Map.has_key?(grid, pos) do
      new_pos = {x + dx, y + dy}
      iter(grid, new_pos, {dx, dy}, [{x, y} | acc])
    else
      acc
    end
  end
end

defmodule GCD do
  # euclid's algorithm
  def gcd(a, 0) do
    abs(a)
  end

  def gcd(a, b) do
    gcd(b, rem(a, b))
  end
end

antenna_groups =
  grid
  |> Enum.filter(fn {_, char} -> char != "." end)
  |> Enum.group_by(fn {_, char} -> char end)
  |> Enum.map(fn {char, positions} ->
    {char, positions |> Enum.map(fn {position, _} -> position end)}
  end)

positions =
  antenna_groups
  |> Enum.map(fn {_, antennas} ->
    antenna_pairs =
      for {p1, i} <- Enum.with_index(antennas),
          {p2, j} <- Enum.with_index(antennas),
          i < j,
          do: {p1, p2}

    Enum.reduce(antenna_pairs, [], fn {p1, p2}, acc ->
      Antenna.resonant_positions(grid, p1, p2) ++ acc
    end)
  end)
  |> List.flatten()
  |> Enum.uniq()

IO.inspect(length(positions))
