# "2333133121414131402"
# "2333133121414131402"
{:ok, contents} = File.read("data/day9.txt")

defmodule Parse do
  def parse([], {_, acc}) do
    Enum.reverse(acc)
  end

  def parse([size, gap | tail], {i, acc}) do
    parse(tail, {i + 1, [{:gap, gap}, {i, size}] ++ acc})
  end

  def parse([size | tail], {i, acc}) do
    parse(tail, {i + 1, [{i, size}] ++ acc})
  end

  def checksum(disk, disk_backward, checksum, i, max_i) do
    # IO.inspect({i, max_i, disk})

    if i < max_i do
      case disk do
        [] ->
          checksum

        [{:gap, size} | disk_tail] ->
          if size > 0 do
            {take_id, disk_backward} = take(disk_backward)
            # IO.inspect({i, "gap", take_id, size})

            checksum(
              [{:gap, size - 1} | disk_tail],
              disk_backward,
              checksum + take_id * i,
              i + 1,
              max_i
            )
          else
            checksum(disk_tail, disk_backward, checksum, i, max_i)
          end

        [{id, size} | disk_tail] ->
          if size > 0 do
            # IO.inspect({i, "disk", id, size})
            checksum([{id, size - 1} | disk_tail], disk_backward, checksum + id * i, i + 1, max_i)
          else
            checksum(disk_tail, disk_backward, checksum, i, max_i)
          end
      end
    else
      checksum
    end
  end

  def take(disk_backward) do
    case disk_backward do
      [] ->
        {0, []}

      [{id, size} | tail] ->
        if size > 0 do
          {id, [{id, size - 1} | tail]}
        else
          take(tail)
        end
    end
  end
end

disk =
  contents
  |> String.graphemes()
  |> Enum.map(&String.to_integer/1)
  |> Parse.parse({0, []})

disk_reversed =
  disk
  |> Enum.filter(fn {mode, _} ->
    mode != :gap
  end)
  |> Enum.reverse()

# IO.inspect(disk)
# IO.inspect(disk_reversed)
max_i = disk_reversed |> Enum.map(fn {_, size} -> size end) |> Enum.sum()
IO.puts(max_i)

IO.inspect(Parse.checksum(disk, disk_reversed, 0, 0, max_i))
