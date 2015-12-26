defmodule Tetris.Tetramino.ShapeTest do
  use ExUnit.Case, async: true
  doctest Tetris.Tetramino.Shape
  doctest Tetris.Tetramino

  test "#random returns a Tetramino.Shape" do
    assert Enum.count(Tetris.Tetramino.Shape.random) <= 4
  end

  test "#random returns a (mostly) random shape" do
    assert Tetris.Tetramino.Shape.random != Tetris.Tetramino.Shape.random
  end

  test "#rotate_right rotates piece one step to the right" do
    original_piece = Tetris.Tetramino.Shape.get_shape(1)

    assert original_piece == [
      [0,0,1,0],
      [0,0,1,0],
      [0,0,1,0],
      [0,0,1,0]
    ]
    rotated_piece = Tetris.Tetramino.Shape.rotate_right(original_piece)

    assert rotated_piece == [
      [0,0,0,0],
      [0,0,0,0],
      [1,1,1,1],
      [0,0,0,0]
    ]
    second_rotated_piece = Tetris.Tetramino.Shape.rotate_right(rotated_piece)

    assert second_rotated_piece == [
      [0,1,0,0],
      [0,1,0,0],
      [0,1,0,0],
      [0,1,0,0]
    ]
    third_rotated_piece = Tetris.Tetramino.Shape.rotate_right(second_rotated_piece)

    assert third_rotated_piece == [
      [0,0,0,0],
      [1,1,1,1],
      [0,0,0,0],
      [0,0,0,0]
    ]
    fourth_rotated_piece = Tetris.Tetramino.Shape.rotate_right(third_rotated_piece)

    assert fourth_rotated_piece == original_piece
  end

  test "#rotate_left rotates piece one step to the left" do
    original_piece = Tetris.Tetramino.Shape.get_shape(1)

    assert original_piece == [
      [0,0,1,0],
      [0,0,1,0],
      [0,0,1,0],
      [0,0,1,0]
    ]
    rotated_piece = Tetris.Tetramino.Shape.rotate_left(original_piece)

    assert rotated_piece == [
      [0,0,0,0],
      [1,1,1,1],
      [0,0,0,0],
      [0,0,0,0]
    ]
    second_rotated_piece = Tetris.Tetramino.Shape.rotate_left(rotated_piece)

    assert second_rotated_piece == [
      [0,1,0,0],
      [0,1,0,0],
      [0,1,0,0],
      [0,1,0,0]
    ]
    third_rotated_piece = Tetris.Tetramino.Shape.rotate_left(second_rotated_piece)

    assert third_rotated_piece == [
      [0,0,0,0],
      [0,0,0,0],
      [1,1,1,1],
      [0,0,0,0]
    ]
    fourth_rotated_piece = Tetris.Tetramino.Shape.rotate_left(third_rotated_piece)

    assert fourth_rotated_piece == original_piece
  end
end
