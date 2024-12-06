{:ok, contents} = File.read("data/day5.txt")
[rules_raw, updates_raw] = String.split(contents, "\n\n")

rules =
  rules_raw
  |> String.split("\n")
  |> Enum.map(fn line ->
    [left, right] =
      String.split(line, "|")

    {{left, right}, true}
  end)
  |> Enum.into(%{})

updates = updates_raw |> String.split("\n") |> Enum.map(fn line -> String.split(line, ",") end)

defmodule Update do
  def p1_validate(rules, [v1, v2 | tail]) do
    if Map.get(rules, {v2, v1}) do
      false
    else
      p1_validate(rules, [v2 | tail])
    end
  end

  def p1_validate(_, [_]) do
    true
  end

  def p2_fix({changed, sorted}, [v1], rules) do
    final = Enum.reverse([v1 | sorted])

    if changed do
      p2_fix({false, []}, final, rules)
    else
      final
    end
  end

  def p2_fix({changed, sorted}, [v1, v2 | tail], rules) do
    # v2 should be before v2
    if Map.get(rules, {v2, v1}) do
      p2_fix({true, [v2 | sorted]}, [v1 | tail], rules)
    else
      p2_fix({changed, [v1 | sorted]}, [v2 | tail], rules)
    end
  end
end

sum =
  updates
  |> Enum.map(fn update ->
    {Update.p1_validate(rules, update), update}
  end)
  |> Enum.filter(fn {valid, _} -> valid end)
  |> Enum.map(fn {_, update} ->
    num = Enum.at(update, div(length(update), 2))
    String.to_integer(num)
  end)
  |> Enum.sum()

IO.inspect(sum)

sum =
  updates
  |> Enum.map(fn update ->
    {Update.p1_validate(rules, update), update}
  end)
  |> Enum.filter(fn {valid, _} -> not valid end)
  |> Enum.map(fn {_, update} -> update end)
  |> Enum.map(fn update ->
    # IO.puts("---")
    # IO.inspect(update)

    # lookup = update |> Enum.map(fn v1 -> {v1, true} end) |> Enum.into(%{})

    # IO.inspect(Update.p2_fix({false, []}, update, rules))

    update = Update.p2_fix({false, []}, update, rules)
    update

    # filtered_rules =
    #   rules
    #   |> Map.keys()
    #   |> Enum.filter(fn {source, target} ->
    #     Map.has_key?(lookup, source) and Map.has_key?(lookup, target)
    #   end)

    # # build a graph
    # graph = :digraph.new()
    # Enum.each(update, fn v -> :digraph.add_vertex(graph, v) end)

    # Enum.each(filtered_rules, fn {source, target} ->
    #   :digraph.add_vertex(graph, source, target)
    # end)

    # topsort = :digraph_utils.topsort(graph)

    # case topsort do
    #   false ->
    #     IO.inspect("HEY!")

    #   _ ->
    #     nil
    # end

    # IO.inspect(topsort)
    # topsort
  end)
  |> Enum.map(fn update ->
    # IO.inspect(update)
    num = Enum.at(update, div(length(update), 2))
    String.to_integer(num)
  end)
  |> Enum.sum()

IO.inspect(sum)

# part 2 starts
# |> Enum.sum()

# setup a digraph
# graph = :digraph.new()

# Enum.each(rules, fn {source, target} ->
#   case :digraph.vertex(graph, source) do
#     false -> :digraph.add_vertex(graph, source)
#     _ -> nil
#   end

#   case :digraph.vertex(graph, target) do
#     false -> :digraph.add_vertex(graph, target)
#     _ -> nil
#   end

#   :digraph.add_edge(graph, source, target)
# end)

# IO.inspect(graph)
# topsort = :digraph_utils.topsort(graph) |> Enum.with_index() |> Enum.into(%{})

# IO.inspect(topsort)
# # IO.inspect(updates)

# results =
#   Enum.map(updates, fn update ->
#     result =
#       Enum.reduce_while(update, -1, fn vertex, order ->
#         vertexOrder = Map.get(topsort, vertex)

#         if vertexOrder > order do
#           {:cont, vertexOrder}
#         else
#           {:halt, :halt}
#         end
#       end)

#     case result do
#       :halt -> {false, update}
#       _ -> {true, update}
#     end
#   end)
#   |> Enum.filter(fn {valid, _} -> valid end)
#   |> Enum.map(fn {_, update} -> String.to_integer(Enum.at(update, div(length(update), 2))) end)
#   |> Enum.sum()

# IO.inspect(results)
