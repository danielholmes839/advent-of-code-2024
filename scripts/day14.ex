defmodule Day14 do
  def final_position({x, y}, {vx, vy}, {width, height}, seconds) do
    {x, y} = {x + vx * seconds, y + vy * seconds}
    {x, y} = {rem(x, width), rem(y, height)}
    # account for negatives
    {rem(x + width, width), rem(y + height, height)}
  end

  def quadrant({x, y}, {midx, midy}) do
    cond do
      x < midx and y < midy ->
        :topleft

      x < midx and y > midy ->
        :bottomleft

      x > midx and y < midy ->
        :topright

      x > midx and y > midy ->
        :bottomright

      true ->
        :mid
    end
  end

  def draw(robots, {width, height}) do
    robots = robots |> Enum.group_by(fn pos -> pos end)

    for y <- 0..(height - 1) do
      row =
        for x <- 0..(width - 1), into: "" do
          if Map.has_key?(robots, {x, y}) do
            "#"
          else
            " "
          end
        end

      IO.puts(row)
    end
  end
end

{:ok, content} = File.read("data/day14.txt")

robots =
  content
  |> String.split("\n")
  |> Enum.map(fn line ->
    [start, velocity] = line |> String.trim("p=") |> String.split(" v=")
    [x, y] = String.split(start, ",")
    [vx, vy] = String.split(velocity, ",")
    {{String.to_integer(x), String.to_integer(y)}, {String.to_integer(vx), String.to_integer(vy)}}
  end)

dims = {101, 103}
mid = {50, 51}
# seconds = 100

1..100_000
|> Enum.map(fn seconds ->
  # IO.puts("-------------------")

  robots =
    robots
    |> Enum.map(fn {pos, vel} ->
      Day14.final_position(pos, vel, dims, seconds)
    end)

  if length(Enum.uniq(robots)) == 500 do
    Day14.draw(robots, dims)
    IO.puts(seconds)
    exit("")
  end
end)

# |> Enum.group_by(fn pos -> Day14.quadrant(pos, mid) end)
# |> Map.delete(:mid)
# |> Map.values()
# |> Enum.map(&length/1)
# |> Enum.reduce(1, fn len, acc -> acc * len end)

# IO.inspect(safety)
