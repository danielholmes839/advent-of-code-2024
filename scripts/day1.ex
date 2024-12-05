{:ok, contents} = File.read("data/day1.txt")

lines = String.split(contents, "\n")

lines =
  Enum.reduce(lines, %{left: [], right: []}, fn line, %{left: left, right: right} ->
    [left_str, right_str] = String.split(line, "   ")
    %{left: [String.to_integer(left_str) | left], right: [String.to_integer(right_str) | right]}
  end)

distance =
  [Enum.sort(lines.left), Enum.sort(lines.right)]
  |> Enum.zip()
  |> Enum.map(fn {left, right} -> abs(left - right) end)
  |> Enum.sum()

# part 1
IO.puts(distance)

# num of times each id from left appears in right

counts =
  Enum.reduce(lines.left, %{}, fn id, counts ->
    Map.put(counts, id, 0)
  end)

counts =
  Enum.reduce(lines.right, counts, fn id, counts ->
    if Map.has_key?(counts, id) do
      %{counts | id => Map.get(counts, id) + 1}
    else
      counts
    end
  end)

IO.inspect(counts)

similarity =
  Enum.reduce(lines.left, 0, fn id, sum ->
    sum + Map.get(counts, id) * id
  end)

IO.puts(similarity)
