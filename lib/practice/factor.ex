defmodule Practice.Factor do

  #if the given number divided by the given factor has no remainder, it is a factor so now
  #recall the function to check if the same factor is also a factor of the divided number
  def numFactor(number, factor, factors) when rem(trunc(number), factor) == 0, do:
    numFactor(number / factor, factor, [factor | factors])
  #if the remainder is not 0, check if the next number is a factor
  def numFactor(number, factor, factors) when number > 1, do:
    numFactor(number, factor + 1, factors)
  #if the number we are checking has reached 1 or below, it was been completly factored, so
  #return the list of factors
  def numFactor(number, _factors, factors) when number <= 1, do:
    factors

  def factor(x) do
    numFactor(x, 2, []) |> Enum.reverse()
  end

end
