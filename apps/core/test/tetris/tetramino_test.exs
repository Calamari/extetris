defmodule Tetris.Tetramino.ShapeTest do
  use ExUnit.Case, async: true
  doctest Tetris.Tetramino.Shape

  test "#random returns a Tetramino.Shape" do
    assert Enum.count(Tetris.Tetramino.Shape.random) <= 4
  end

  test "#random returns a (mostly) random shape" do
    assert Tetris.Tetramino.Shape.random != Tetris.Tetramino.Shape.random
  end

  test "#rotate_right rotates piece one step to the right" do
    original_piece = Tetris.Tetramino.Shape.get_shape(1)

    assert original_piece == [
      [1],
      [1],
      [1],
      [1]
    ]
    rotated_piece = Tetris.Tetramino.Shape.rotate_right(original_piece)

    assert rotated_piece == [
      [1,1,1,1]
    ]
    second_rotated_piece = Tetris.Tetramino.Shape.rotate_right(rotated_piece)

    assert second_rotated_piece == [
      [1],
      [1],
      [1],
      [1]
    ]
    third_rotated_piece = Tetris.Tetramino.Shape.rotate_right(second_rotated_piece)

    assert third_rotated_piece == [
      [1,1,1,1]
    ]
    fourth_rotated_piece = Tetris.Tetramino.Shape.rotate_right(third_rotated_piece)

    assert fourth_rotated_piece == original_piece
  end

  test "#rotate_left rotates piece one step to the left" do
    original_piece = Tetris.Tetramino.Shape.get_shape(1)

    assert original_piece == [
      [1],
      [1],
      [1],
      [1]
    ]
    rotated_piece = Tetris.Tetramino.Shape.rotate_left(original_piece)

    assert rotated_piece == [
      [1,1,1,1]
    ]
    second_rotated_piece = Tetris.Tetramino.Shape.rotate_left(rotated_piece)

    assert second_rotated_piece == [
      [1],
      [1],
      [1],
      [1]
    ]
    third_rotated_piece = Tetris.Tetramino.Shape.rotate_left(second_rotated_piece)

    assert third_rotated_piece == [
      [1,1,1,1]
    ]
    fourth_rotated_piece = Tetris.Tetramino.Shape.rotate_left(third_rotated_piece)

    assert fourth_rotated_piece == original_piece
  end
end

defmodule Tetris.TetraminoTest do
  use ExUnit.Case, async: true
  doctest Tetris.Tetramino

  test "#create_random returns a (mostly) random Tetramino" do
    assert Tetris.Tetramino.create_random.shape != Tetris.Tetramino.create_random.shape
  end

  test "#create_random always positions on y:0" do
    assert Tetris.Tetramino.create_random.y == 0
  end

  test "#create_from_shape positions the item correctly" do
    assert Tetris.Tetramino.create_from_shape(1).x == 5
    assert Tetris.Tetramino.create_from_shape(2).x == 4
    assert Tetris.Tetramino.create_from_shape(3).x == 4
    assert Tetris.Tetramino.create_from_shape(4).x == 4
    assert Tetris.Tetramino.create_from_shape(5).x == 4
    assert Tetris.Tetramino.create_from_shape(6).x == 4
    assert Tetris.Tetramino.create_from_shape(7).x == 4
  end

  test "#rotate_right rotates piece one step to the right" do
    original_piece = Tetris.Tetramino.create_from_shape(1)

    assert original_piece.shape == [
      [1],
      [1],
      [1],
      [1]
    ]
    rotated_piece = Tetris.Tetramino.rotate_right(original_piece)

    assert rotated_piece.shape == [
      [1,1,1,1]
    ]
    second_rotated_piece = Tetris.Tetramino.rotate_right(rotated_piece)

    assert second_rotated_piece.shape == [
      [1],
      [1],
      [1],
      [1]
    ]
    third_rotated_piece = Tetris.Tetramino.rotate_right(second_rotated_piece)

    assert third_rotated_piece.shape == [
      [1,1,1,1]
    ]
    fourth_rotated_piece = Tetris.Tetramino.rotate_right(third_rotated_piece)

    assert fourth_rotated_piece == original_piece
  end

  test "#rotate_left rotates piece one step to the left" do
    original_piece = Tetris.Tetramino.create_from_shape(1)

    assert original_piece.shape == [
      [1],
      [1],
      [1],
      [1]
    ]
    rotated_piece = Tetris.Tetramino.rotate_left(original_piece)

    assert rotated_piece.shape == [
      [1,1,1,1]
    ]
    second_rotated_piece = Tetris.Tetramino.rotate_left(rotated_piece)

    assert second_rotated_piece.shape == [
      [1],
      [1],
      [1],
      [1]
    ]
    third_rotated_piece = Tetris.Tetramino.rotate_left(second_rotated_piece)

    assert third_rotated_piece.shape == [
      [1,1,1,1]
    ]
    fourth_rotated_piece = Tetris.Tetramino.rotate_left(third_rotated_piece)

    assert fourth_rotated_piece == original_piece
  end

  test "#rotating a stone with dimensions 3:2 does not affect x size" do
    original_piece = Tetris.Tetramino.create_from_shape(3)
    rotated_piece = Tetris.Tetramino.rotate_left(original_piece)
    second_rotated_piece = Tetris.Tetramino.rotate_left(rotated_piece)

    assert original_piece.x == rotated_piece.x
    assert original_piece.x == second_rotated_piece.x
  end

  test "#rotating a stone with dimensions 4:1 does affect x size" do
    original_piece = Tetris.Tetramino.create_from_shape(1)
    rotated_piece = Tetris.Tetramino.rotate_left(original_piece)
    second_rotated_piece = Tetris.Tetramino.rotate_left(rotated_piece)

    assert original_piece.x == rotated_piece.x+1
    assert original_piece.x == second_rotated_piece.x
  end

  test "#rotating a shape and it will be out of the board, if is in again" do
    original_piece = %Tetris.Tetramino{Tetris.Tetramino.create_from_shape(1) | x: 0}
    rotated_piece = Tetris.Tetramino.rotate_left(original_piece)

    assert rotated_piece.x == 0

    original_piece = %Tetris.Tetramino{Tetris.Tetramino.create_from_shape(1) | x: 9}
    rotated_piece = Tetris.Tetramino.rotate_left(original_piece)

    assert rotated_piece.x == 6
  end
end
