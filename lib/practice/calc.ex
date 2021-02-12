defmodule Practice.Calc do
  #---------------COMPUTE---------------works
  def operation(tokens, op, first, second, ans) do
    case op do
      "+" -> compute(tokens, [first + second | ans])
      "-" -> compute(tokens, [second - first | ans]) #check here for bugs
      "*" -> compute(tokens, [first * second | ans])
      "/" -> compute(tokens, [second / first | ans])
    end 
  end
  
  def compute(tokens, ans) do
    try do
      case elem(List.first(tokens), 0) do
        :op -> operation(List.delete_at(tokens, 0), elem(List.first(tokens), 1), Enum.at(ans, length(ans)-2), Enum.at(ans, length(ans)-1), Enum.drop(ans, -2)) 
        :num -> compute(List.delete_at(tokens, 0), [elem(List.first(tokens), 1) | ans])
      end
    rescue 
      ArgumentError -> ans
    end
  end
    
  #--------------POSTFIX----------------
  def get_prec(op) do
    case elem(op, 1) do
      "*" -> 1
      "/" -> 1
      "+" -> 0
      "-" -> 0
    end
  end

  def is_prec(cur_op, op_from_stack) do
    get_prec(op_from_stack) >= get_prec(cur_op) #check equals for bug
  end 

  def handle_op(list, op, operators, result) when length(operators) === 0, do: 
    postfix(list, [op | operators], result)
  def handle_op(list, op, operators, result) when length(operators) !== 0 do
    if get_prec(op) < get_prec(List.first(operators)) do
      postfix(list, [op | List.delete_at(operators, 0)], [List.first(operators) | result])
    else postfix(list, [op | operators], result)
    end
  end

  def postfix(li, opstack, res) do
    try do
      case elem(List.first(li), 0) do
        :num -> postfix(List.delete_at(li, 0), opstack, [List.first(li) | res])
        :op -> handle_op(List.delete_at(li, 0), List.first(li), opstack, res) 
      end
    rescue
      ArgumentError -> [opstack |> Enum.reverse | res] |> List.flatten |> Enum.reverse #end of list 
    end
  end

  #-------------TAG_TOKENS---------------works
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def add_tags(t) do
    case t do
       t when t in ["+", "-", "*", "/"] -> {:op, t}
       _ -> {:num, parse_float(t)}
    end
  end

  #"5" -> {:num, 5.0}; "+" -> {:op, "+"}
  def tag_tokens(list) do
     Enum.map(list, fn x -> add_tags(x) end)
  end

  #-----------------CALC-----------------
  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/)
    |> tag_tokens()
    |> postfix([], [])
    #|> compute([])
    #|> Enum.at(0)
    #|> trunc()

    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end
end
