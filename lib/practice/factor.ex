defmodule Practice.Factor do
  #ideas taken from jlangr on exercism.io

  #if no remainder, add the factor to the list; call again with the same factor and the new number
  def numFactor(number, factor, factors) when rem(trunc(number), factor) == 0, do:
  numFactor(number / factor, factor, [factor | factors])

  #if there is a remainder, check if the next number is a prime factor
  def numFactor(number, factor, factors) when number > 1, do: numFactor(number, factor + 1, factors)

  #if the number is now 1 or below, factoring is complete to return
  def numFactor(number, _factors, factors) when number <= 1, do: factors

  def factor(x) do
    numFactor(x, 2, []) |> Enum.reverse() #returns in [x,y,z] format
  end
end
