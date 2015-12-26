defmodule Tetris.PlayerTest do
  use ExUnit.Case, async: true
  doctest Tetris.Player

  test "Player can have a name" do
    player = %Tetris.Player{name: 'John'}

    assert player.name == 'John'
  end

  test "Player has no board (it will be assigned on game start)" do
    assert is_nil %Tetris.Player{}.board
  end
end
