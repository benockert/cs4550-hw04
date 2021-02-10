defmodule Practice.Palindrome do
  def check_same(rev, orig) do
    orig === rev
  end

  def isPalindrome(x) do
    x
    |> String.reverse()
    |> check_same(x)
  end
end
