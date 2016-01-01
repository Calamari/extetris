defmodule Tetris.Tetramino do

  defmodule Shape do
    @doc """
    Returns shape of piece with given number.
    """
    def get_shape(number) do
      case number do
        1 -> [
          [1],
          [1],
          [1],
          [1]
        ]
        2 -> [
          [2,2],
          [2,2]
        ]
        3 -> [
          [0,3,3],
          [3,3,0]
        ]
        4 -> [
          [4,4,0],
          [0,4,4]
        ]
        5 -> [
          [5,0],
          [5,0],
          [5,5]
        ]
        6 -> [
          [0,6],
          [0,6],
          [6,6]
        ]
        7 -> [
          [7,7,7],
          [0,7,0]
        ]
      end
    end

    def random do
      get_shape Enum.random [1,2,3,4,5,6,7]
    end

    def rotate_right(shape) do
      Matrix.rotate_right(shape)
    end

    def rotate_left(shape) do
      Matrix.rotate_left(shape)
    end
  end

  defstruct shape: Shape.random(), x: 3, y: 0

  @doc """
  Creates a tetramino using given shape

  iex> Tetris.Tetramino.create_from_shape(Tetris.Tetramino.Shape.get_shape(2))
  %Tetris.Tetramino{shape: [
    [2,2],
    [2,2],
  ], x: 4, y: 0}

  iex> Tetris.Tetramino.create_from_shape(2)
  %Tetris.Tetramino{shape: [
    [2,2],
    [2,2],
  ], x: 4, y: 0}
  """
  def create_from_shape(num) when is_number(num) do
    create_from_shape Tetris.Tetramino.Shape.get_shape(num)
  end

  def create_from_shape(shape) do
    create shape
  end

  def create_random do
    create Shape.random
  end

  defp create(shape) do
    {w, _h} = Matrix.size shape
    %Tetris.Tetramino{shape: shape, x: 5 - trunc(w / 2)}
  end

  def rotate_left(tetramino) do
    new_shape = Shape.rotate_left(tetramino.shape)
    x_adjust = shape_adjustment(new_shape)
    adjust_stone_to_board %Tetris.Tetramino{tetramino | shape: new_shape, x: tetramino.x + x_adjust}
  end

  def rotate_right(tetramino) do
    new_shape = Shape.rotate_right(tetramino.shape)
    x_adjust = -shape_adjustment(new_shape)
    adjust_stone_to_board %Tetris.Tetramino{tetramino | shape: new_shape, x: tetramino.x + x_adjust}
  end

  defp shape_adjustment(shape) do
    cond do
      Matrix.num_rows(shape) == 1 -> -1
      Matrix.num_rows(shape) == 4 -> 1
      true                        -> 0
    end
  end

  @doc """
  Moves given tetramino one row down
  iex> tetramino = Tetris.Tetramino.create_from_shape(2)
  iex> Tetris.Tetramino.move_down(tetramino)
  %Tetris.Tetramino{shape: [
    [2,2],
    [2,2],
  ], x: 4, y: 1}
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
