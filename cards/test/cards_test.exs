defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "contain card in deck" do
    assert Cards.contains?(["Ace", "Two"], "Ace") == true
  end

  test "not contain card in deck" do
    assert Cards.contains?(["Ace", "Two"], "Three") == false
  end
end
