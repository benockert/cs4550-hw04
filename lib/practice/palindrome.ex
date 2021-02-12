defmodule Practice.Palindrome do
  def check_same(rev, orig) do
    orig === rev
  end

  def isPalindrome(x) do
    x
    |> String.reverse() #reverses the string
    |> check_same(x) #checks that the reverse is the same as the original string
  end
end
