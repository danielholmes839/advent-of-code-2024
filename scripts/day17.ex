defmodule Day17 do
  def step(acc, program, iptr, register) do
    opcode = Map.get(program, iptr)
    operand = Map.get(program, iptr + 1)

    if opcode == nil do
      IO.inspect(register)
      acc
    else
      {acc, {a, b, c}, iptr} =
        case op(opcode, operand, register) do
          {:out, combo_op} ->
            IO.inspect(combo_op)

            {
              acc * 10 + combo_op,
              register,
              iptr + 2
            }

          {new_register, new_iptr} ->
            {acc, new_register, new_iptr}

          new_register ->
            {acc, new_register, iptr + 2}
        end

      step(acc, program, iptr, {a, b, c})
    end
  end

  def combo(operand, {a, b, c}) do
    cond do
      operand <= 3 -> operand
      operand == 4 -> a
      operand == 5 -> b
      operand == 6 -> c
      # invalid
      operand == 7 -> exit("impossible!")
    end
  end

  def op(0, operand, {a, b, c}) do
    combo_operand = combo(operand, {a, b, c})
    a = div(a, 2 ** combo_operand)
    {a, b, c}
  end

  def op(1, operand, {a, b, c}) do
    b = Bitwise.bxor(b, operand)
    {a, b, c}
  end

  def op(2, operand, {a, b, c}) do
    combo_operand = combo(operand, {a, b, c})
    b = rem(combo_operand, 8)
    {a, b, c}
  end

  def op(3, operand, {a, b, c}) do
    if a != 0 do
      {{a, b, c}, operand}
    else
      {a, b, c}
    end
  end

  def op(4, _, {a, b, c}) do
    b = Bitwise.bxor(b, c)
    {a, b, c}
  end

  def op(5, operand, register) do
    combo_op = combo(operand, register)
    {:out, rem(combo_op, 8)}
  end

  def op(6, operand, {a, b, c}) do
    combo_operand = combo(operand, {a, b, c})
    b = div(a, 2 ** combo_operand)
    {a, b, c}
  end

  def op(7, operand, {a, b, c}) do
    combo_operand = combo(operand, {a, b, c})
    c = div(a, 2 ** combo_operand)
    {a, b, c}
  end
end

program =
  [2, 4, 1, 2, 7, 5, 1, 7, 4, 4, 0, 3, 5, 5, 3, 0]
  |> Enum.with_index()
  |> Enum.map(fn {op, i} -> {i, op} end)
  |> Enum.into(%{})

acc = Day17.step(0, program, 0, {41_644_071, 0, 0})
IO.inspect(acc |> Integer.to_string() |> String.graphemes() |> Enum.join(","))
