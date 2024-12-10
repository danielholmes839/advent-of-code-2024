# "2333133121414131402"
# "2333133121414131402"
{:ok, contents} = File.read("data/day9.txt")
# contents = "2333133121414131402"

defmodule Parse do
  def parse([], {_, _, acc}) do
    Enum.reverse(acc)
  end

  def parse([file_size, gap_size | tail], {i, index, acc}) do
    parse(
      tail,
      {i + 1, index + file_size + gap_size,
       [
         %{kind: :gap, index: index + file_size, size: gap_size, id: i},
         %{kind: :file, index: index, size: file_size, id: i}
       ] ++ acc}
    )
  end

  def parse([file_size | tail], {i, index, acc}) do
    parse(tail, {nil, nil, [%{kind: :file, index: index, size: file_size, id: i}] ++ acc})
  end

  def find_best_gap(gaps, file) do
    best_gap_id =
      0..max(file.id - 1, 0)
      |> Enum.find(fn gap_id ->
        gap = Map.get(gaps, gap_id)
        gap.index < file.index and gap.size >= file.size
      end)

    case best_gap_id do
      nil ->
        nil

      _ ->
        Map.get(gaps, best_gap_id)
    end
  end

  def update_file(file_id, files, gaps) do
  end

  def move(files, gaps, file, gap) do
    {%{files | file.id => %{file | index: gap.index}},
     %{gaps | gap.id => %{gap | index: gap.index + file.size, size: gap.size - file.size}}}
  end

  def update(files, gaps, file_id) do
    file = Map.get(files, file_id)
    best_gap = find_best_gap(gaps, file)

    case best_gap do
      nil ->
        # IO.puts("don't move")
        {files, gaps}

      _ ->
        # IO.inspect({"replace", file.id, best_gap.id})
        move(files, gaps, file, best_gap)
    end
  end
end

disk =
  contents
  |> String.graphemes()
  |> Enum.map(&String.to_integer/1)
  |> Parse.parse({0, 0, []})

IO.inspect(disk)

files =
  disk
  |> Enum.filter(fn
    %{kind: kind} when kind == :file -> true
    _ -> false
  end)
  |> Enum.reverse()
  |> Enum.map(fn file -> {file.id, file} end)
  |> Enum.into(%{})

gaps =
  disk
  |> Enum.filter(fn
    %{kind: kind} when kind == :gap -> true
    _ -> false
  end)
  |> Enum.map(fn gap -> {gap.id, gap} end)
  |> Enum.into(%{})

# IO.inspect(disk)
# IO.inspect(gaps)
# IO.inspect(map_size(files))

{files, _} =
  (map_size(files) - 1)..0//-1
  |> Enum.reduce({files, gaps}, fn file_id, {acc_files, acc_gaps} ->
    Parse.update(acc_files, acc_gaps, file_id)
  end)

sum =
  files
  |> Map.values()
  |> Enum.map(fn file ->
    # IO.inspect(file)

    Enum.map(file.index..(file.index + file.size - 1), fn index ->
      # IO.inspect({index, file.id})
      index * file.id
    end)
    |> Enum.sum()
  end)
  |> Enum.sum()

IO.inspect(sum)

# IO.inspect(Parse.find_best_gap(gaps, Map.get(files, 9)))

# max_i = disk_reversed |> Enum.map(fn {_, size} -> size end) |> Enum.sum()
# IO.puts(max_i)

# IO.inspect(Parse.checksum(disk, disk_reversed, 0, 0, max_i))
