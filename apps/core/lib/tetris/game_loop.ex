defmodule Tetris.GameLoop do
  def start(boards, ms) do
    spawn(fn -> loop(boards, ms) end)
  end

  def loop(boards, ms) do
    Enum.map boards, fn (board) ->
      Tetris.Board.tick board
    end
    receive do
      {:tick} -> loop(boards, ms)
      {:adjust_time, new_ms} -> loop(boards, new_ms)
      {:stop} ->
    after
      ms -> loop(boards, ms)
    end
  end
end
