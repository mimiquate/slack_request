defmodule SlackRequestTest do
  use ExUnit.Case
  doctest SlackRequest

  test "greets the world" do
    assert SlackRequest.hello() == :world
  end
end
