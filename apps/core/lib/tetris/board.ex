defmodule Tetris.Board do
  use GenServer

  alias Tetris.Tetramino

  @number_rows 22
  @hidden_rows 2


  @row [0,0,0,0,0,0,0,0,0,0]

  defmodule State do
    @row [0,0,0,0,0,0,0,0,0,0]
    defstruct rows: [
        # @number_rows rows (the top most 2 rows are hidden from the player)
        @row, @row, @row, @row, @row, @row, @row, @row, @row, @row,
        @row, @row, @row, @row, @row, @row, @row, @row, @row, @row,
        @row, @row
      ],
      is_finished: false,
      next_stone: nil,
      current_stone: nil
  end


  @doc """
  Starts a new game of Tetris
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, {:ok, opts[:next_stone_callback]}, [])
  end


  @doc """
  Returns true if board is empty
  """
  def is_empty(state) do
    state.rows == %Tetris.Board.State{}.rows
  end


  @doc """
  Returns a new state
  """
  def create_board do
    {:ok, board} = Tetris.Board.start_link
    board
  end

  @doc """
  Returns an Array of Array representation of the current board including the current
  stone that is flying down.
  """
  def get_current_layout(board) do
    rows = GenServer.call(board, {:get_rows})
    stone = GenServer.call(board, {:get_stone})
    if stone do
      rows = fix_stone_to_board(stone, rows)
    end
    rows
  end

  defp padded_stone(tetramino) do
    pad_size_before = tetramino.x
    pad_size_after = 10 - (Matrix.num_columns(tetramino.shape) + tetramino.x)
    Enum.map tetramino.shape, fn(row) ->
      Matrix.pad_row(row, pad_size_before) |>
      Matrix.pad_row_after(pad_size_after)
    end
  end

  defp fix_stone_to_board(tetramino, rows) do
    rows_on_the_board = Enum.min [Matrix.num_rows(tetramino.shape), Matrix.num_rows(rows) - tetramino.y]
    spliced_rows = rows
                   |> Matrix.rows_at(tetramino.y, rows_on_the_board)
                   |> Matrix.add padded_stone(tetramino)
                   |> Matrix.rows_at 0, rows_on_the_board
    Matrix.replace_rows(rows, tetramino.y, spliced_rows)
  end

  @doc """
  Returns an Array of Array representation of the current board of all stones that
  did already fall down.
  """
  def get_fixed_layout(board) do
    GenServer.call(board, {:get_rows})
  end


  @doc """
  Sets board to a specific layout
  """
  def set_layout(board, layout) do
    GenServer.call(board, {:set_layout, layout})
  end


  @doc """
  Moves the current stone one down or fixes it, if it is on the bottom.
  """
  def tick(board) do
    GenServer.call(board, {:tick})
  end


  @doc """
  Tells you, if the game is finished already
  """
  def finished?(board) do
    GenServer.call(board, {:is_finished})
  end


  @doc """
  Fixes the current stone to the bottom of the lane where it falls down.
  """
  def drop_stone(board) do
    GenServer.call(board, {:drop_stone})
  end


  # @doc """
  # Moves the current stone one down or fixes it, if it is on the bottom.
  # """
  # def valid_position?(board, tetramino) do
  #   GenServer.call(board, {:is_valid_position, tetramino})
  # end


  @doc """
  Sets stone onto the board
  """
  def set_stone(board, tetramino) do
    GenServer.call(board, {:set_stone, tetramino})
  end


  @doc """
  Returns the current stone on the board
  """
  def get_current_stone(board) do
    GenServer.call(board, {:get_stone})
  end


  @doc """
  Removes one row. The number is the (zero starting) index of row starting
  from the bottom. Maximum is 20.
  Return `:ok` if ok, and `{:error, :WRONG_NUMBER}` otherwise
  """
  @spec remove_row(pid, number) :: any

  def remove_row(board, index) when index >= 0 and index <= (@number_rows - @hidden_rows) do
    GenServer.call(board, {:remove_row, index})
  end

  def remove_row(_, _)  do
    {:error, :WRONG_NUMBER}
  end


  @doc """
  Checks if given row is completely full
  """
  def row_full?(row) do
    !Enum.any? row, fn (x) -> x == 0 end
  end

  ## Server Callbacks

  def init({:ok, next_stone_callback}) do
    next_stone_callback = cond do
      next_stone_callback -> next_stone_callback
      true -> fn -> Tetris.Tetramino.create_random end
    end

    state = %{state: %State{}, next_stone_callback: next_stone_callback}
    {:ok, state}
  end


  def handle_call({:get_rows}, _from, state) do
    {:reply, state.state.rows, state}
  end


  @doc """
  Removes rows counted from the bottom
  """
  def handle_call({:remove_row, index}, _from, state) do
    {:reply, :ok, do_remove_row(state, @number_rows - index - 1)}
  end

  defp do_remove_rows(state, []), do: state

  defp do_remove_rows(state, [index|rows]) do
    state
    |> do_remove_row(index)
    |> do_remove_rows(rows)
  end

  defp do_remove_row(state, index) do
    rows = state.state.rows |>
      Matrix.remove_row(index) |>
      Matrix.insert_row(0, @row)
    state = Dict.put(state, :state, %{state.state | rows: rows})
  end

  def handle_call({:set_layout, rows}, _from, state) do
    state = Dict.put(state, :state, %{state.state | rows: rows})
    {:reply, state.state.rows, state}
  end


  def handle_call({:set_stone, tetramino}, _from, state) do
    state = Dict.put(state, :state, %{state.state | current_stone: tetramino})
    {:reply, :ok, state}
  end


  def handle_call({:get_stone}, _from, state) do
    {:reply, state.state.current_stone, state}
  end


  def handle_call({:is_finished}, _from, state) do
    {:reply, state.state.is_finished, state}
  end

  def handle_call({:drop_stone}, _from, state) do
    tetramino = state.state.current_stone
    if tetramino do
      rows = do_drop_stone(tetramino, state.state.rows) |>
        fix_stone_to_board state.state.rows
      state = Dict.put(state, :state, %{state.state | current_stone: nil, rows: rows})
    end
    {:reply, :ok, state}
  end


  def handle_call({:tick}, _from, state) do
    if !state.state.is_finished do
      state = do_tick(state, state.state.current_stone)
    end
    {:reply, state.state.current_stone, state}
  end

  defp do_tick(state, nil) do
    filled_rows = get_filled_rows(state)
    if !Enum.empty?(filled_rows) do
      do_remove_rows(state, filled_rows)
    else
      create_new_tetramino(state)
    end
  end
  defp do_tick(state, tetramino) do
    move_tetramino_down(state, tetramino)
  end

  defp get_filled_rows(state) do
    t=Matrix.map_rows state.state.rows, fn (row, index) ->
      if row_full?(row), do: index, else: nil
    end
    Enum.filter t, &(&1)
  end

  defp create_new_tetramino(state) do
    new_tetramino = state.next_stone_callback.()
    is_finished = !valid_position?(new_tetramino, state.state.rows)
    Dict.put(state, :state, %{state.state | current_stone: new_tetramino, is_finished: is_finished})
  end

  defp move_tetramino_down(state, tetramino) do
    next_tetramino = Tetramino.move_down(tetramino)
    rows = state.state.rows
    cond do
      valid_position?(next_tetramino, rows) ->
        Dict.put(state, :state, %{state.state | current_stone: next_tetramino})
      :else ->
        rows = fix_stone_to_board(tetramino, rows)
        Dict.put(state, :state, %{state.state | current_stone: nil, rows: rows})
    end
  end

  defp do_drop_stone(tetramino, rows) do
    next_tetramino = Tetramino.move_down(tetramino)
    if valid_position?(next_tetramino, rows), do: do_drop_stone(next_tetramino, rows), else: tetramino
  end

  # def handle_call({:is_valid_position, tetramino}, _from, state) do
  #   {:reply, valid?(tetramino, state.state.rows), state}
  # end

  @doc """
  Checks if tetramino's position is valid on given board layout.

  Meaning that it is not outside the board or on top of stones already fallen down.
  """
  def valid_position?(tetramino, rows) do
    !below_board?(tetramino) &&
      !left_of_board?(tetramino) &&
      !right_of_board?(tetramino) &&
      !any_collision?(tetramino, rows)
  end

  defp any_collision?(tetramino, rows) do
    {w, h} = Matrix.size(tetramino.shape)
    rows
    |> Matrix.slice(tetramino.x, tetramino.y, w, h)
    |> Stream.zip(tetramino.shape)
    |> Enum.any? fn {ra, rb} ->
      Stream.zip(ra, rb) |>
        Enum.any? fn {a, b} -> a != 0 && b != 0 end
    end
  end

  defp below_board?(tetramino) do
    Matrix.num_rows(tetramino.shape) + tetramino.y > 22
  end

  defp left_of_board?(tetramino) do
    tetramino.x < 0
  end

  defp right_of_board?(tetramino) do
    Matrix.num_columns(tetramino.shape) + tetramino.x > 10
  end
end
