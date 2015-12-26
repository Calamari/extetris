defmodule Tetris.BoardTest do
  use ExUnit.Case, async: true
  doctest Tetris.Board

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
    [0,0,0,0,0,0,0,1,0,0],
    [1,1,1,1,1,1,1,1,1,1],
    [1,1,1,1,1,1,1,1,1,0],
    [0,0,1,0,0,0,1,0,0,0]
  ]

  @some_playground_after_removing [
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
    [0,0,0,0,0,0,0,1,0,0],
    [1,1,1,1,1,1,1,1,1,0],
    [0,0,1,0,0,0,1,0,0,0]
  ]

  @empty_playground [
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
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0]
  ]

  setup do
    {:ok, board} = Tetris.Board.start_link
    {:ok, board: board}
  end

  test "We can get the current layout", %{board: board} do
    assert Tetris.Board.get_current_layout(board) == @empty_playground
  end

  test "We can set a specific layout of the board", %{board: board} do
    Tetris.Board.set_layout(board, @some_playground)

    assert Tetris.Board.get_current_layout(board) == @some_playground
  end

  test "Board.row_full? returns true only for full rows" do
    assert true == Tetris.Board.row_full?([1,1,1,1,1,1,1,1,1,1])
    assert true == Tetris.Board.row_full?([2,2,2,2,1,2,1,2,2,2])

    assert false == Tetris.Board.row_full?([1,1,1,0,1,1,1,1,1,1])
  end

  test "#get_fixed_layout does not contain the stone flying around", %{board: board} do
    Tetris.Board.set_stone(board, Tetris.Tetramino.create_from_shape(2))
    assert Tetris.Board.get_fixed_layout(board) == [
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
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0]
    ]
  end

  test "#get_current_layout always contains the stone flying around", %{board: board} do
    Tetris.Board.set_stone(board, Tetris.Tetramino.create_from_shape(2))
    assert Tetris.Board.get_current_layout(board) == [
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,2,2,0,0,0,0],
      [0,0,0,0,2,2,0,0,0,0],
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
      [0,0,0,0,0,0,0,0,0,0]
    ]
  end

  test "We can remove one row (the top ones move down)", %{board: board} do
    Tetris.Board.set_layout(board, @some_playground)

    Tetris.Board.remove_row(board, 2)

    assert Tetris.Board.get_current_layout(board) == @some_playground_after_removing
  end

  test "#remove_row handles right numbers and errors wrong ones", %{board: board} do
    assert {:error, :WRONG_NUMBER} == Tetris.Board.remove_row(board, -1)
    assert :ok == Tetris.Board.remove_row(board, 0)
    assert :ok == Tetris.Board.remove_row(board, 20)
    assert {:error, :WRONG_NUMBER} == Tetris.Board.remove_row(board, 21)
  end

  test "#tick moves the current stone one down", %{board: board} do
    initial_stone = %Tetris.Tetramino{}
    Tetris.Board.set_stone(board, initial_stone)
    assert Tetris.Board.get_current_stone(board) == %{initial_stone | y: 0}

    Tetris.Board.tick(board)
    assert Tetris.Board.get_current_stone(board) == %{initial_stone | y: 1}

    Tetris.Board.tick(board)
    assert Tetris.Board.get_current_stone(board) == %{initial_stone | y: 2}
  end

  test "#tick fixes stone if it is on the bottom already", %{board: board} do
    initial_stone = %Tetris.Tetramino{ shape: Tetris.Tetramino.Shape.get_shape(1), y: 18}
    Tetris.Board.set_stone(board, initial_stone)

    Tetris.Board.tick(board)
    assert is_nil Tetris.Board.get_current_stone(board)

    assert Tetris.Board.get_fixed_layout(board) == [
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
      [0,0,0,0,0,1,0,0,0,0],
      [0,0,0,0,0,1,0,0,0,0],
      [0,0,0,0,0,1,0,0,0,0],
      [0,0,0,0,0,1,0,0,0,0]
    ]
  end

  test "#tick gets you a new random stone if last one is fixed", %{board: board} do
    initial_stone = %Tetris.Tetramino{ shape: Tetris.Tetramino.Shape.get_shape(1), y: 18}
    Tetris.Board.set_stone(board, initial_stone)

    Tetris.Board.tick(board)
    assert is_nil Tetris.Board.get_current_stone(board)

    Tetris.Board.tick(board)
    assert not is_nil Tetris.Board.get_current_stone(board)
  end

  test "#valid_position? checks if stone is outside board", _ do
    tetramino = Tetris.Tetramino.create_from_shape(1)

    # to the bottom
    assert Tetris.Board.valid_position?(%Tetris.Tetramino{tetramino | y: 18}, @empty_playground) == true
    assert Tetris.Board.valid_position?(%Tetris.Tetramino{tetramino | y: 19}, @empty_playground) == false

    # to the left
    assert Tetris.Board.valid_position?(%Tetris.Tetramino{tetramino | x: -1}, @empty_playground) == true
    assert Tetris.Board.valid_position?(%Tetris.Tetramino{tetramino | x: -2}, @empty_playground) == true
    assert Tetris.Board.valid_position?(%Tetris.Tetramino{tetramino | x: -3}, @empty_playground) == false

    # to the right
    assert Tetris.Board.valid_position?(%Tetris.Tetramino{tetramino | x: 7}, @empty_playground) == true
    assert Tetris.Board.valid_position?(%Tetris.Tetramino{tetramino | x: 8}, @empty_playground) == false
  end

  test "#valid_position? checks if stone is on top of other stone", _ do
    tetramino = Tetris.Tetramino.create_from_shape(4) # Z-shape

    assert Tetris.Board.valid_position?(%Tetris.Tetramino{tetramino | x: 6, y: 16}, @some_playground) == true
    assert Tetris.Board.valid_position?(%Tetris.Tetramino{tetramino | x: 5, y: 16}, @some_playground) == false
  end
end