defmodule Tetris.Tetramino do

  defmodule Shape do
    @doc """
    Returns shape of piece with given number.
    """
    def get_shape(number) do
      case number do
        1 -> [
          [0,0,1,0],
          [0,0,1,0],
          [0,0,1,0],
          [0,0,1,0]
        ]
        2 -> [
          [0,0,0,0],
          [0,2,2,0],
          [0,2,2,0],
          [0,0,0,0]
        ]
        3 -> [
          [0,0,0,0],
          [0,3,3,0],
          [3,3,0,0],
          [0,0,0,0]
        ]
        4 -> [
          [0,0,0,0],
          [0,4,4,0],
          [0,0,4,4],
          [0,0,0,0]
        ]
        5 -> [
          [0,5,0,0],
          [0,5,0,0],
          [0,5,5,0],
          [0,0,0,0]
        ]
        6 -> [
          [0,0,6,0],
          [0,0,6,0],
          [0,6,6,0],
          [0,0,0,0]
        ]
        7 -> [
          [0,0,0,0],
          [0,7,7,7],
          [0,0,7,0],
          [0,0,0,0]
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
    [0,0,0,0],
    [0,2,2,0],
    [0,2,2,0],
    [0,0,0,0]
  ], x: 3, y: 0}

  iex> Tetris.Tetramino.create_from_shape(2)
  %Tetris.Tetramino{shape: [
    [0,0,0,0],
    [0,2,2,0],
    [0,2,2,0],
    [0,0,0,0]
  ], x: 3, y: 0}
  """
  def create_from_shape(num) when is_number(num) do
    create_from_shape Tetris.Tetramino.Shape.get_shape(num)
  end

  def create_from_shape(shape) do
    %Tetris.Tetramino{shape: shape}
  end

  @doc """
  Moves given tetramino one row down
  iex> tetramino = Tetris.Tetramino.create_from_shape(2)
  iex> Tetris.Tetramino.move_down(tetramino)
  %Tetris.Tetramino{shape: [
    [0,0,0,0],
    [0,2,2,0],
    [0,2,2,0],
    [0,0,0,0]
  ], x: 3, y: 1}
  """
  def move_down(tetramino) do
    %Tetris.Tetramino{tetramino | y: tetramino.y+1}
  end
end
