defmodule PanaceaTest do
  use ExUnit.Case
  doctest Panacea

  test "greets the world" do
    assert Panacea.hello() == :world
  end
end
