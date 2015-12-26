defmodule Tetris.Control do

  @doc """
  Moves a stone to the left or right. Returns the new Tetramino.

  If Tetramino got dropped, you won't get a tetramino back, because it was
  dropped already, and added to the board.
  """
  @spec handle({pid, struct}, :atom) :: struct

  def handle({board, _}, :drop) do
    Tetris.Board.drop_stone(board)
    nil
  end
  def handle({board, tetramino}, :move_down) do
    new_tetramino = %Tetris.Tetramino{tetramino | y: tetramino.y+1}
    layout = Tetris.Board.get_fixed_layout(board)
    cond do
      Tetris.Board.valid_position?(new_tetramino, layout) -> new_tetramino
      :else                                               ->
        Tetris.Board.drop_stone(board)
        nil
    end
  end

  def handle({board, tetramino}, dir) do
    new_tetramino = do_handle(tetramino, dir)
    layout = Tetris.Board.get_fixed_layout(board)
    cond do
      Tetris.Board.valid_position?(new_tetramino, layout) -> new_tetramino
      :else                                               -> tetramino
    end
  end

  defp do_handle(tetramino, :move_right) do
    %Tetris.Tetramino{tetramino | x: tetramino.x+1}
  end
  defp do_handle(tetramino, :move_left) do
    %Tetris.Tetramino{tetramino | x: tetramino.x-1}
  end
end
