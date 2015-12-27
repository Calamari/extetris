defmodule Tetris.Control do

  @doc """
  Moves a stone to the left or right. Returns the new Tetramino.

  If Tetramino got dropped, you won't get a tetramino back, because it was
  dropped already, and added to the board.
  """
  @spec handle({pid, struct}, :atom) :: struct

  def handle(board, :drop) do
    Tetris.Board.drop_stone(board)
    nil
  end
  def handle(board, :move_down) do
    tetramino = Tetris.Board.get_current_stone(board)
    new_tetramino = %Tetris.Tetramino{tetramino | y: tetramino.y+1}
    layout = Tetris.Board.get_fixed_layout(board)
    cond do
      Tetris.Board.valid_position?(new_tetramino, layout) ->
        Tetris.Board.set_stone(board, new_tetramino)
      :else                                               ->
        Tetris.Board.drop_stone(board)
        nil
    end
  end

  def handle(board, dir) do
    tetramino = Tetris.Board.get_current_stone(board)
    new_tetramino = do_handle(tetramino, dir)
    layout = Tetris.Board.get_fixed_layout(board)
    tetramino = cond do
      Tetris.Board.valid_position?(new_tetramino, layout) -> new_tetramino
      :else                                               -> tetramino
    end
    Tetris.Board.set_stone(board, tetramino)
  end

  defp do_handle(tetramino, :move_right) do
    %Tetris.Tetramino{tetramino | x: tetramino.x+1}
  end
  defp do_handle(tetramino, :move_left) do
    %Tetris.Tetramino{tetramino | x: tetramino.x-1}
  end
  defp do_handle(tetramino, :rotate_left) do
    Tetris.Tetramino.rotate_left tetramino
  end
  defp do_handle(tetramino, :rotate_right) do
    Tetris.Tetramino.rotate_right tetramino
  end
end
