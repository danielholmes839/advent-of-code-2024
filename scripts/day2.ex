defmodule Safe do
  def is_safe?([e1, e2 | tail], tolerance, prev) do
    diff = e1 - e2

    cond do
      diff > 0 and diff <= 3 ->
        is_safe?([e2 | tail], tolerance, e1)

      tolerance - 1 >= 0 and prev != nil ->
        # IO.inspect([tolerance, e1, e2, tail])
        is_safe?([prev, e1 | tail], tolerance - 1, nil) or
          is_safe?([prev, e2 | tail], tolerance - 1, nil)

      tolerance - 1 >= 0 and prev == nil ->
        # IO.inspect([tolerance, e1, e2, tail])
        is_safe?([e2 | tail], tolerance - 1, nil) or
          is_safe?([e1 | tail], tolerance - 1, nil)

      true ->
        false
    end
  end

  def is_safe?([_], _, _) do
    true
  end
end

{:ok, contents} = File.read("data/day2.txt")

tolerance = 1

sequences =
  contents
  |> String.split("\n")
  |> Enum.map(fn line ->
    line |> String.split(" ") |> Enum.map(fn num -> String.to_integer(num) end)
  end)

IO.inspect(sequences)

sequences =
  sequences
  |> Enum.filter(fn sequence ->
    Safe.is_safe?(sequence, 1, nil) or Safe.is_safe?(Enum.reverse(sequence), 1, nil)
  end)

IO.inspect(sequences)

safe = length(sequences)

IO.inspect(safe)

# IO.inspect(Sorted.is_safe?(hd(sequences)))

# a = [1, 2, 3]

# [e1, e2 | tail] = a

# IO.inspect([e1 | tail])
# IO.inspect([e2 | tail])
