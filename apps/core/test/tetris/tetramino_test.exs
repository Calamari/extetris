defmodule Tetris.TetraminoTest do
  use ExUnit.Case, async: true
  doctest Tetris.Tetramino

  test "#create_random returns a (mostly) random Tetramino" do
    assert Tetris.Tetramino.create_random.shape != Tetris.Tetramino.create_random.shape
  end

  test "#create has correct positionings initially" do
    assert Tetris.Tetramino.create(1).x == 5
    assert Tetris.Tetramino.create(1).y == 1
    assert Tetris.Tetramino.create(2).x == 4
    assert Tetris.Tetramino.create(2).y == 2
    assert Tetris.Tetramino.create(3).x == 4
    assert Tetris.Tetramino.create(3).y == 2
    assert Tetris.Tetramino.create(4).x == 4
    assert Tetris.Tetramino.create(4).y == 2
    assert Tetris.Tetramino.create(5).x == 4
    assert Tetris.Tetramino.create(5).y == 1
    assert Tetris.Tetramino.create(6).x == 3
    assert Tetris.Tetramino.create(6).y == 1
    assert Tetris.Tetramino.create(7).x == 4
    assert Tetris.Tetramino.create(7).y == 2
  end

  test "#get_rotation returns the current rotation tupel" do
    tupel = Tetris.Tetramino.get_rotation(1, [[1,1,1,1]])
    assert tupel == {[
      [1,1,1,1]
    ], -1, 0}
  end

  test "#get_rotation(:right) returns the next rotation tupel" do
    tupel = Tetris.Tetramino.get_rotation(:right, 1, [[1],[1],[1],[1]])
    assert tupel == {[
      [1,1,1,1]
    ], -1, 0}
  end

  test "#get_rotation(:right) returns the next rotation tupel and wraps around the rotation cycle" do
    tupel = Tetris.Tetramino.get_rotation(:right, 1, [[1,1,1,1]])
    assert tupel == {[
      [1],
      [1],
      [1],
      [1]
    ], 1, -1}
  end

  test "#get_rotation(:left) returns the previous rotation tupel" do
    tupel = Tetris.Tetramino.get_rotation(:left, 1, [[1],[1],[1],[1]])
    assert tupel == {[
      [1,1,1,1]
    ], -1, 0}
  end

  test "#get_rotation(:left) returns the previous rotation tupel and wraps around the rotation cycle" do
    tupel = Tetris.Tetramino.get_rotation(:left, 1, [[1,1,1,1]])
    assert tupel == {[
      [1],
      [1],
      [1],
      [1]
    ], 1, -1}
  end

  test "#rotate(:right) rotates piece to the right and adapts the positioning to feel right" do
    original_piece = Tetris.Tetramino.create(1)

    assert original_piece.shape == [
      [1],
      [1],
      [1],
      [1]
    ]
    assert original_piece.x == 5
    assert original_piece.y == 1
    rotated_piece = Tetris.Tetramino.rotate(:right, original_piece)

    assert rotated_piece.shape == [
      [1,1,1,1]
    ]
    assert rotated_piece.x == 3
    assert rotated_piece.y == 2
    second_rotated_piece = Tetris.Tetramino.rotate(:right, rotated_piece)

    assert second_rotated_piece == original_piece
  end

  test "#rotate(:left) rotates piece to the left and adapts the positioning to feel right" do
    original_piece = Tetris.Tetramino.create(7)

    assert original_piece.shape == [
        [7,7,7],
        [0,7,0]
    ]
    assert original_piece.x == 4
    assert original_piece.y == 2
    rotated_piece = Tetris.Tetramino.rotate(:left, original_piece)

    assert rotated_piece.shape == [
        [7,0],
        [7,7],
        [7,0]
    ]
    assert rotated_piece.x == 5
    assert rotated_piece.y == 1
    second_rotated_piece = Tetris.Tetramino.rotate(:left, rotated_piece)

    assert second_rotated_piece.shape == [
        [0,7,0],
        [7,7,7]
    ]
    assert second_rotated_piece.x == 4
    assert second_rotated_piece.y == 2
    third_rotated_piece = Tetris.Tetramino.rotate(:left, second_rotated_piece)

    fourth_rotated_piece = Tetris.Tetramino.rotate(:left, third_rotated_piece)
    assert fourth_rotated_piece == original_piece
  end

  test "#rotating a shape and it will be out of the board, if is in again" do
    original_piece = %Tetris.Tetramino{Tetris.Tetramino.create(1) | x: 0}
    rotated_piece = Tetris.Tetramino.rotate(:right, original_piece)

    assert rotated_piece.x == 0

    original_piece = %Tetris.Tetramino{Tetris.Tetramino.create(1) | x: 9}
    rotated_piece = Tetris.Tetramino.rotate(:right, original_piece)

    assert rotated_piece.x == 6
  end
end
