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
  def resonant_positions({x1, y1}, {x2, y2}) do
    {dx, dy} = {x2 - x1, y2 - y1}

    outer_positions = [{x2 + dx, y2 + dy}, {x1 - dx, y1 - dy}]

    inner_positions =
      if rem(dx, 3) == 0 and rem(dy, 3) == 0 do
        dx_third = div(dx, 3)
        dy_third = div(dy, 3)
        [{x1 + dx_third, y1 + dy_third}, {x2 - dx_third, y2 - dy_third}]
      else
        []
      end

    outer_positions ++ inner_positions
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
      Antenna.resonant_positions(p1, p2) ++ acc
    end)
  end)
  |> List.flatten()
  |> Enum.filter(fn position -> Map.has_key?(grid, position) end)
  |> Enum.uniq()

# IO.inspect(positions)
IO.inspect(length(positions))
