defmodule Practice.Factor do
  def n_primes(n), do: prime(n, 2)
  def is_prime(x), do: (2..x |> Enum.filter(fn a -> rem(x, a) == 0 end) |> length()) == 1
  def prime(n, n), do: []
  def prime(n, acc) do
    case is_prime(acc) do
      true -> [acc | prime(n, acc + 1)]
      false -> prime(n, acc + 1)
    end
  end

  def numFactor(factor, number) do
    if rem(trunc(number), factor) == 0 do
      [factor | numFactor(factor, number / factor)]
    else
      []
    end 
  end 


  def factor(x) do
    Enum.map(n_primes(x+1), fn prime -> numFactor(prime, x) -- [[]] end) |> List.flatten()
  end

end
