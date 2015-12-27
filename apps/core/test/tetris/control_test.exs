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
    {:ok, board: board, empty_board: empty_board}
  end

  # TODO: remove tetramino from handle call. We can get it from the board itself
  test "#handle handles moving right", %{board: board} do
    Tetris.Control.handle(board, :move_right)
    assert Tetris.Board.get_current_stone(board).x == 4
    Tetris.Control.handle(board, :move_right)
    assert Tetris.Board.get_current_stone(board).x == 5
    Tetris.Control.handle(board, :move_right)
    assert Tetris.Board.get_current_stone(board).x == 6
    Tetris.Control.handle(board, :move_right)
    assert Tetris.Board.get_current_stone(board).x == 7
    Tetris.Control.handle(board, :move_right)
    assert Tetris.Board.get_current_stone(board).x == 7
  end

  test "#handle handles moving left", %{board: board} do
    Tetris.Control.handle(board, :move_left)
    assert Tetris.Board.get_current_stone(board).x == 2
    Tetris.Control.handle(board, :move_left)
    assert Tetris.Board.get_current_stone(board).x == 1
    Tetris.Control.handle(board, :move_left)
    assert Tetris.Board.get_current_stone(board).x == 0
    Tetris.Control.handle(board, :move_left)
    assert Tetris.Board.get_current_stone(board).x == -1
    Tetris.Control.handle(board, :move_left)
    assert Tetris.Board.get_current_stone(board).x == -1
  end

  test "#handle handles moving down", %{empty_board: board} do
    Tetris.Control.handle(board, :move_down)
    assert Tetris.Board.get_current_stone(board).y == 1
    Tetris.Control.handle(board, :move_down)
    assert Tetris.Board.get_current_stone(board).y == 2
    Tetris.Control.handle(board, :move_down)
    assert Tetris.Board.get_current_stone(board).y == 3
  end

  test "#handle handles rotating left", %{empty_board: board} do
    tetramino = Tetris.Tetramino.create_from_shape(1)
    Tetris.Board.set_stone board, tetramino

    Tetris.Control.handle(board, :rotate_left)
    assert Tetris.Board.get_current_stone(board).shape == [
      [0,0,0,0],
      [1,1,1,1],
      [0,0,0,0],
      [0,0,0,0]
    ]
  end

  test "#handle handles rotating right", %{empty_board: board} do
    tetramino = Tetris.Tetramino.create_from_shape(1)
    Tetris.Board.set_stone board, tetramino

    Tetris.Control.handle(board, :rotate_right)
    assert Tetris.Board.get_current_stone(board).shape == [
      [0,0,0,0],
      [0,0,0,0],
      [1,1,1,1],
      [0,0,0,0]
    ]
  end

  test "#handle fixes stone when moving down when it is already at the bottom", %{empty_board: empty_board} do
    tetramino = %Tetris.Tetramino{Tetris.Board.get_current_stone(empty_board) | y: 18 }
    Tetris.Board.set_stone empty_board, tetramino
    Tetris.Control.handle(empty_board, :move_down)
    assert Tetris.Board.get_current_stone(empty_board).y == 19

    Tetris.Control.handle(empty_board, :move_down)
    assert is_nil Tetris.Board.get_current_stone(empty_board)
    assert Tetris.Board.get_fixed_layout(empty_board) == @empty_playground_after_drop
  end

  test "#handle allows to drop piece to the bottom", %{board: board, empty_board: empty_board} do
    Tetris.Control.handle(board, :drop)

    assert is_nil Tetris.Board.get_current_stone(board)
    assert Tetris.Board.get_fixed_layout(board) == @some_playground_after_drop

    Tetris.Control.handle(empty_board, :drop)

    assert is_nil Tetris.Board.get_current_stone(empty_board)
    assert Tetris.Board.get_fixed_layout(empty_board) == @empty_playground_after_drop
  end
end
