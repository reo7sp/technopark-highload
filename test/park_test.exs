defmodule ParkTest do
  use ExUnit.Case
  doctest Park

  test "greets the world" do
    assert Park.hello() == :world
  end
end
