defmodule Tetris.ControlTest do
  use ExUnit.Case, async: true
  doctest Tetris.Control

  @some_playground [
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,1,1,1,0,0],
    [0,0,1,0,0,0,1,0,0,0]
  ]
  @some_playground_after_drop [
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,2,2,0,0,0,0],
    [0,0,0,0,2,2,0,0,0,0],
    [0,0,0,0,0,1,1,1,0,0],
    [0,0,1,0,0,0,1,0,0,0]
  ]
  @empty_playground_after_drop [
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,2,2,0,0,0,0],
    [0,0,0,0,2,2,0,0,0,0],
  ]

  setup do
    {:ok, empty_board} = Tetris.Board.start_link
    {:ok, board} = Tetris.Board.start_link
    Tetris.Board.set_layout board, @some_playground
    tetramino = Tetris.Tetramino.create_from_shape(2)
    Tetris.Board.set_stone board, tetramino
    Tetris.Board.set_stone empty_board, tetramino
    {:ok, board: board, empty_board: empty_board, tetramino: tetramino}
  end

  # TODO: remove tetramino from handle call. We can get it from the board itself
  test "#handle handles moving right", %{board: board, tetramino: tetramino} do
    tetramino = Tetris.Control.handle({board, tetramino}, :move_right)
    assert tetramino.x == 4
    tetramino = Tetris.Control.handle({board, tetramino}, :move_right)
    assert tetramino.x == 5
    tetramino = Tetris.Control.handle({board, tetramino}, :move_right)
    assert tetramino.x == 6
    tetramino = Tetris.Control.handle({board, tetramino}, :move_right)
    assert tetramino.x == 7
    tetramino = Tetris.Control.handle({board, tetramino}, :move_right)
    assert tetramino.x == 7
  end

  test "#handle handles moving left", %{board: board, tetramino: tetramino} do
    tetramino = Tetris.Control.handle({board, tetramino}, :move_left)
    assert tetramino.x == 2
    tetramino = Tetris.Control.handle({board, tetramino}, :move_left)
    assert tetramino.x == 1
    tetramino = Tetris.Control.handle({board, tetramino}, :move_left)
    assert tetramino.x == 0
    tetramino = Tetris.Control.handle({board, tetramino}, :move_left)
    assert tetramino.x == -1
    tetramino = Tetris.Control.handle({board, tetramino}, :move_left)
    assert tetramino.x == -1
  end

  test "#handle handles moving down", %{empty_board: board, tetramino: tetramino} do
    tetramino = Tetris.Control.handle({board, tetramino}, :move_down)
    assert tetramino.y == 1
    tetramino = Tetris.Control.handle({board, tetramino}, :move_down)
    assert tetramino.y == 2
    tetramino = Tetris.Control.handle({board, tetramino}, :move_down)
    assert tetramino.y == 3
  end

  test "#handle fixes stone when moving down when it is already at the bottom", %{empty_board: empty_board, tetramino: tetramino} do
    tetramino = %Tetris.Tetramino{tetramino | y: 18 }
    Tetris.Board.set_stone empty_board, tetramino
    tetramino = Tetris.Control.handle({empty_board, tetramino}, :move_down)
    assert tetramino.y == 19

    tetramino = Tetris.Control.handle({empty_board, tetramino}, :move_down)
    assert is_nil Tetris.Board.get_current_stone(empty_board)
    assert Tetris.Board.get_fixed_layout(empty_board) == @empty_playground_after_drop
  end

  test "#handle allows to drop piece to the bottom", %{board: board, empty_board: empty_board, tetramino: tetramino} do
    Tetris.Control.handle({board, tetramino}, :drop)

    assert is_nil Tetris.Board.get_current_stone(board)
    assert Tetris.Board.get_fixed_layout(board) == @some_playground_after_drop

    Tetris.Control.handle({empty_board, tetramino}, :drop)

    assert is_nil Tetris.Board.get_current_stone(empty_board)
    assert Tetris.Board.get_fixed_layout(empty_board) == @empty_playground_after_drop
  end
end
