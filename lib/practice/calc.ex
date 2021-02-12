defmodule Practice.Calc do
  #--------------------COMPUTE----------------------
  def do_op(tokens, op, first, second, ans) do
    case op do
      "+" -> compute(tokens, [first + second | ans])
      "-" -> compute(tokens, [second - first | ans])
      "*" -> compute(tokens, [first * second | ans])
      "/" -> compute(tokens, [second / first | ans])
    end
  end

  def compute(tokens, ans) do
    try do
      case elem(List.first(tokens), 0) do
        :op -> do_op(List.delete_at(tokens, 0), #remove token now that it's being handled
                     elem(List.first(tokens), 1), #gets the operation string
                     Enum.at(ans, 0), #first number
                     Enum.at(ans, 1), #second number
                     Enum.drop(ans, 2)) #removes those two numbers now that they're being computed
        :num -> compute(List.delete_at(tokens, 0), #removes token now thats its beinghandled
                        [elem(List.first(tokens), 1) | ans]) #adds number to the answer stack
      end
    rescue
      ArgumentError -> ans #end of list
    end
  end

  #----------------------POSTFIX---------------------
  def get_prec(op) do
    case elem(op, 1) do
      "*" -> 1 #multiplication and division have same precedence
      "/" -> 1
      "+" -> 0 #addition and subtration have same precedence
      "-" -> 0
    end
  end

  def handle_op(list, op, operators, result) when length(operators) === 0 do
    postfix(list, [op | operators], result)
  end

  def handle_op(list, op, operators, result) when length(operators) > 0 do
    if get_prec(op) <= get_prec(List.first(operators)) do
      postfix(list, [op | List.delete_at(operators, 0)], [List.first(operators) | result])
    else postfix(list, [op | operators], result)
    end
  end

  def postfix(tokens, opstack, res) do
    try do
      case elem(List.first(tokens), 0) do
        :num -> postfix(List.delete_at(tokens, 0), #removes the first token since its being handled
                        opstack, #no change to the operation stack
                        [List.first(tokens) | res]) #add the number to the postfix result
        :op -> handle_op(List.delete_at(tokens, 0), #removes token since its being handled
                         List.first(tokens), #gets operator tokens
                         opstack, #no change to the operator stack (will be modified in handle_op)
                        res) #no change to the result yet (will possibly be modified in handle_op)
      end
    rescue
      ArgumentError -> [opstack |> Enum.reverse | res] |> List.flatten |> Enum.reverse #end of list
    end
  end

  #-----------------------TAG_TOKENS-------------------
  #taken from starter code
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def add_tags(t) do
    if t in ["+", "-", "*", "/"] do
      {:op, t}
    else {:num, parse_float(t)}
    end
  end

  #"5" -> {:num, 5.0}; "+" -> {:op, "+"}
  def tag_tokens(list) do
    Enum.map(list, fn x -> add_tags(x) end)
  end

  #-------------------------CALC-----------------------
  def calc(expr) do
    expr
    |> String.split(~r/\s+/) #split input string into list
    |> tag_tokens() #tag each token with either :num or :op
    |> postfix([], []) #convert to postfix format
    |> compute([]) #compute the answer from postfix format
    |> Enum.at(0) #returns [x], so get the first (and only) element
    |> trunc() #and truncate it
  end
end
