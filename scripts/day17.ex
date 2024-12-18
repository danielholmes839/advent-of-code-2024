defmodule Day17 do
  def step(program, iptr, register) do
    opcode = Map.get(program, iptr)
    operand = Map.get(program, iptr + 1)

    # IO.inspect({iptr, register, {opcode, operand}})

    if opcode == nil or operand == nil do
      IO.inspect(register)
    else
      {{a, b, c}, iptr} =
        case op(opcode, operand, register) do
          {new_register, new_iptr} -> {new_register, new_iptr}
          new_register -> {new_register, iptr + 2}
        end

      step(program, iptr, {a, b, c})
    end
  end

  def combo(operand, {a, b, c}) do
    cond do
      operand == 4 -> a
      operand == 5 -> b
      operand == 6 -> c
      # invalid
      operand == 7 -> exit("impossible!")
      operand <= 3 -> operand
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
    IO.puts(rem(combo_op, 8))
    register
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
  [0, 1, 5, 4, 3, 0]
  |> Enum.with_index()
  |> Enum.map(fn {op, i} -> {i, op} end)
  |> Enum.into(%{})

Day17.step(program, 0, {2024, 0, 0})
