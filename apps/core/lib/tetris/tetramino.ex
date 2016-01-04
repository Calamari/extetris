defmodule Tetris.Tetramino do
  defstruct shape: nil, nr: 0, x: 3, y: 0

  # Every tupel contains: `{shape, x_offset, y_offset}`
  @rotations %{
    1 => [
      {[
        [1],
        [1],
        [1],
        [1]
      ], 1, -1},
      {[
        [1,1,1,1]
      ], -1, 0}
    ],
    2 => [
      {[
        [2,2],
        [2,2]
      ], 0, 0}
    ],
    3 => [
      {[
        [0,3,3],
        [3,3,0]
      ], 0, 0},
      {[
        [3,0],
        [3,3],
        [0,3]
      ], 0, -1}
    ],
    4 => [
      {[
        [4,4,0],
        [0,4,4]
      ], 0, 0},
      {[
        [0,4],
        [4,4],
        [4,0]
      ], 1, -1}
    ],
    5 => [
      {[
        [5,0],
        [5,0],
        [5,5]
      ], 0, -1},
      {[
        [5,5,5],
        [5,0,0]
      ], -1, 0},
      {[
        [5,5],
        [0,5],
        [0,5]
      ], -1, -1},
      {[
        [0,0,5],
        [5,5,5]
      ], -1, 0}
    ],
    6 => [
      {[
        [0,6],
        [0,6],
        [6,6]
      ], -1, -1},
      {[
        [6,0,0],
        [6,6,6]
      ], -1, 0},
      {[
        [6,6],
        [6,0],
        [6,0]
      ], 0, -1},
      {[
        [6,6,6],
        [0,0,6]
      ], -1, 0}
    ],
    7 => [
      {[
        [7,7,7],
        [0,7,0]
      ], 0, 0},
      {[
        [0,7],
        [7,7],
        [0,7]
      ], 0, -1},
      {[
        [0,7,0],
        [7,7,7]
      ], 0, 0},
      {[
        [7,0],
        [7,7],
        [7,0]
      ], 1, -1}
    ]
  }

  defp get_first_rotation(nr) do
    Enum.at @rotations[nr], 0
  end

  def get_rotations do
    @rotations
  end

  def get_rotation(nr, shape) do
    Enum.at @rotations[nr], get_rotation_index(nr, shape)
  end

  def get_rotation(:right, nr, shape) do
    next_index = get_rotation_index(nr, shape) + 1
    next_index = if next_index >= length(@rotations[nr]), do: 0, else: next_index
    Enum.at @rotations[nr], next_index
  end

  def get_rotation(:left, nr, shape) do
    prev_index = get_rotation_index(nr, shape) - 1
    prev_index = if prev_index < 0, do: length(@rotations[nr]) - 1, else: prev_index
    Enum.at @rotations[nr], prev_index
  end

  defp get_rotation_index(nr, shape) do
    Enum.find_index @rotations[nr], fn ({s, _x, _y}) -> s == shape end
  end

  @doc """
  Creates a random tetramino
  """
  def create_random do
    create random_number
  end

  defp random_number do
    Enum.random [1,2,3,4,5,6,7]
  end

  @doc """
  Creates a tetramino using given shape number

  iex> Tetris.Tetramino.create(2)
  %Tetris.Tetramino{shape: [
    [2,2],
    [2,2],
  ], x: 4, y: 2, nr: 2}
  """
  def create(nr) do
    {shape, x_offset, y_offset} = get_first_rotation(nr)
    %Tetris.Tetramino{shape: shape, x: 4 + x_offset, y: 2 + y_offset, nr: nr}
  end

  def rotate(dir, tetramino) do
    {shape, x_offset, y_offset} = get_rotation(tetramino.nr, tetramino.shape)
    {next_shape, next_x_offset, next_y_offset} = get_rotation(dir, tetramino.nr, tetramino.shape)

    %Tetris.Tetramino{tetramino | shape: next_shape,
                                  x: tetramino.x - x_offset + next_x_offset,
                                  y: tetramino.y - y_offset + next_y_offset}
    |> adjust_stone_to_board
  end

  @doc """
  Moves given tetramino one row down
  iex> tetramino = Tetris.Tetramino.create(2)
  iex> Tetris.Tetramino.move_down(tetramino)
  %Tetris.Tetramino{shape: [
    [2,2],
    [2,2],
  ], x: 4, y: 3, nr: 2}
  """
  def move_down(tetramino) do
    %Tetris.Tetramino{tetramino | y: tetramino.y+1}
  end

  defp adjust_stone_to_board(tetramino) do
    tetramino_width = Matrix.num_columns(tetramino.shape)
    new_x = cond do
      tetramino.x < 0                   -> 0
      tetramino.x > 10 - tetramino_width -> 10 - tetramino_width
      true                              -> tetramino.x
    end
    %Tetris.Tetramino{tetramino | x: new_x}
  end

end
