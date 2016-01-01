defmodule Matrix do
  @moduledoc """
  Matrix is a small lib to do some matrix transformations.
  """

  @typedoc """
  A row is an Array of Numbers.
  """
  @type row :: [number]

  @typedoc """
  A matrix is an Array of Array of Numbers.

  The matrix should always have a uniform layout and not different sized rows.
  """
  @type matrix :: [row]


  @doc """
  Returns number of columns of given matrix.

  iex> Matrix.num_columns([[1,2,3],[3,4,5]])
  3
  """
  @spec num_columns(matrix) :: number

  def num_columns([a|_]) do
    length a
  end


  @doc """
  Returns number of rows of given matrix.
  """
  @spec num_rows(matrix) :: number

  def num_rows(a) do
    length a
  end


  @doc """
  Returns `{columns, rows}` of given matrix.
  """
  @spec size(matrix) :: {number, number}

  def size(a) do
    {num_columns(a), num_rows(a)}
  end


  @doc """
  Adds two same sized matrices together

  iex> Matrix.add([[1,2,3], [2,3,4]], [[1,1,1], [1,6,1]])
  [[2,3,4], [3,9,5]]
  """
  @spec add(matrix, matrix) :: matrix

  def add(matrix1, matrix2) do
    zipped_map matrix1, matrix2, fn({row1, row2}) -> add_rows(row1, row2) end
  end


  @doc """
  Multiplies two same sized matrices together

  iex> Matrix.multiply([[1,2,3], [2,3,4]], [[1,1,2], [1,2,1]])
  [[1,2,6], [2,6,4]]
  """
  @spec multiply(matrix, matrix) :: matrix

  def multiply(matrix1, matrix2) do
    zipped_map matrix1, matrix2, fn({row1, row2}) -> multiply_rows(row1, row2) end
  end


  @doc """
  Subtracts the second matrix from the first one

  iex> Matrix.subtract([[1,2,3], [2,3,4]], [[1,1,2], [1,2,1]])
  [[0,1,1], [1,1,3]]
  """
  @spec subtract(matrix, matrix) :: matrix

  def subtract(matrix1, matrix2) do
    zipped_map matrix1, matrix2, fn({row1, row2}) -> subtract_rows(row1, row2) end
  end

  defp zipped_map(matrix1, matrix2, fun) do
    if size(matrix1) == size(matrix2) do
      Stream.zip(matrix1, matrix2) |>
        Enum.map fun
    else
      {:error, :NOT_SAME_SIZE}
    end
  end

  @doc """
  Invokes the given fun for each item in the matrix and returns true if at least
  one invocation returns true. Returns false otherwise.
  """
  @spec any?(matrix, (number -> as_boolean(term))) :: boolean

  def any?(matrix, fun) do
    Enum.any? matrix, fn row ->
      Enum.any? row, fun
    end
  end

  @doc """
  Zips corresponding elements from two matrices into one matrix of tuples
  """
  @spec zip(matrix, matrix) :: [[{number,number}]]

  def zip(matrix1, matrix2) do
    if size(matrix1) == size(matrix2) do
      Stream.zip(matrix1, matrix2) |>
        Enum.map fn {x,y} -> Enum.zip x, y end
    else
      {:error, :NOT_SAME_SIZE}
    end
  end

  @doc """
  Rotates a given matrix to the right and returns new matrix.

  If the matrix is size {3,4} it will become {4,3}.

  iex> Matrix.rotate_right([[1,2,3],[4,5,6],[7,8,9]])
  [[7,4,1],[8,5,2],[9,6,3]]
  """
  @spec rotate_right(matrix) :: matrix

  def rotate_right(a) do
    # IO.puts inspect a
    # IO.puts inspect b
    Enum.map transpose(a), fn(c) -> Enum.reverse(c) end
  end


  @doc """
  Rotates a given matrix to the left and returns new matrix.

  If the matrix is size {3,4} it will become {4,3}.

  iex> Matrix.rotate_left([[7,4,1],[8,5,2],[9,6,3]])
  [[1,2,3],[4,5,6],[7,8,9]]
  """
  @spec rotate_left(matrix) :: matrix

  def rotate_left(a) do
    # IO.puts inspect a
    # IO.puts inspect b
    Enum.reverse transpose(a)
  end


  defp transpose([[]|_]), do: []
  defp transpose(matrix) do
    [Enum.map(matrix, fn(x) -> hd(x) end) | transpose(Enum.map(matrix, fn(x) -> tl(x) end))]
  end


  @doc """
  Creates a matrix with given dimensions. It can have a initial value to full
  the matrix with. If not given it's all zeros.

  iex> Matrix.create_matrix(2,2)
  [[0,0], [0,0]]
  iex> Matrix.create_matrix(3,2,1)
  [[1,1,1], [1,1,1]]
  """
  @spec create_matrix(number, number) :: matrix
  @spec create_matrix(number, number, number) :: matrix

  def create_matrix(cols, rows, init_value \\ 0) do
    Enum.map 1..rows, fn (_) ->
                        Enum.map 1..cols, fn (_) -> init_value end
                      end
  end


  @doc """
  Removes specified row of given matrix. After this the matrix has one less row.
  The index argument is zero based.
  """
  @spec remove_row(matrix, number) :: matrix

  def remove_row(matrix, index) do
    Enum.slice(matrix, 0, index) ++ Enum.slice(matrix, index+1, Enum.count(matrix))
  end


  @doc """
  Replaces specified row of given matrix with given row.
  The index argument is zero based.
  """
  @spec replace_row(matrix, number, row) :: matrix

  def replace_row(matrix, index, row) do
    replace_rows matrix, index, [row]
  end


  @doc """
  Replaces rows on specified index with given ones. It replaces as many rows as are in the
  new array.
  The index argument is zero based.
  """
  @spec replace_rows(matrix, number, [row]) :: matrix

  def replace_rows(matrix, index, rows) do
    count_rows = length rows
    Enum.slice(matrix, 0, index) ++ rows ++ Enum.slice(matrix, index+count_rows, Enum.count(matrix))
  end


  @doc """
  Adds given row to matrix at specified index.
  The index argument is zero based.
  """
  @spec insert_row(matrix, number, row) :: matrix

  def insert_row(matrix, index, row) do
    Enum.slice(matrix, 0, index) ++ [row] ++ Enum.slice(matrix, index, Enum.count(matrix))
  end


  @doc """
  Calls given callback on every item of matrix and creates a new matrix
  """
  @spec map(matrix, (number -> number)) :: matrix

  def map(matrix, fun) do
    if is_function(fun, 2) do
      matrix
      |> Enum.with_index
      |> Enum.map fn ({row, index}) ->
        Enum.map(row, fn (x) -> fun.(x, index) end)
      end
    else
      Enum.map matrix, fn (row) -> Enum.map(row, fun) end
    end
  end

  @doc """
  Calls given callback on every row of matrix and creates a new array with
  returned values
  """
  @spec map_rows(matrix, (number -> number)) :: matrix

  def map_rows(matrix, fun) do
    if is_function(fun, 2) do
      matrix
      |> Enum.with_index
      |> Enum.map fn ({row, index}) -> fun.(row, index) end
    else
      Enum.map matrix, fun
    end
  end


  @doc """
  Extracts a submatrix out of a bigger matrix
  """
  @spec slice(matrix, number, number, number, number) :: matrix

  def slice(matrix, x, y, w, h) do
    Enum.slice(matrix, y, h) |>
      Enum.map fn (row) -> Enum.slice(row, x, w) end
  end


  @doc """
  Returns one row at given index (zero based from top).

  iex> Matrix.row_at([[1,2,3], [2,3,4], [3,4,5]], 1)
  [2,3,4]
  """
  @spec row_at(matrix, number) :: row

  def row_at(matrix, index) do
    Enum.at matrix, index
  end


  @doc """
  Returns rows at given index (zero based from top) and given number of rows.
  If asked for more rows, it will only return the number of rows that are present.

  iex> Matrix.rows_at([[1,2,3], [2,3,4], [3,4,5]], 0, 2)
  [[1,2,3], [2,3,4]]
  iex> Matrix.rows_at([[1,2,3], [2,3,4], [3,4,5]], 2, 2)
  [[3,4,5]]
  """
  @spec rows_at(matrix, number, number) :: row

  def rows_at(matrix, index, count) do
    Enum.slice matrix, index, count
  end


  @doc """
  Adds two rows together and return a new row

  iex> Matrix.add_rows([1,2,3,4,5,6], [6,5,4,3,2,0])
  [7,7,7,7,7,6]
  """
  @spec add_rows(row, row) :: row

  def add_rows(row1, row2) do
    Stream.zip(row1, row2) |> Enum.map fn({x,y}) -> x + y end
  end


  @doc """
  Multiplies two rows together and return a new row

  iex> Matrix.multiply_rows([1,2,3,4,5,6], [2,2,4,4,1,1])
  [2,4,12,16,5,6]
  """
  @spec multiply_rows(row, row) :: row

  def multiply_rows(row1, row2) do
    Stream.zip(row1, row2) |> Enum.map fn({x,y}) -> x * y end
  end

  @doc """
  Subtract two rows from each other and return a new row

  iex> Matrix.subtract_rows([1,2,3,4,5,6], [2,2,4,4,1,1])
  [-1,0,-1,0,4,5]
  """
  @spec subtract_rows(row, row) :: row

  def subtract_rows(row1, row2) do
    Stream.zip(row1, row2) |> Enum.map fn({x,y}) -> x - y end
  end


  @doc """
  Pads a row at the beginning with given count of maybe given value (or 0)

  iex> Matrix.pad_row([1,2,3,4,5,6], 2)
  [0,0,1,2,3,4,5,6]
  iex> Matrix.pad_row([1,2,3,4,5,6], 2, 3)
  [3,3,1,2,3,4,5,6]
  """
  @spec pad_row(row, number) :: row
  @spec pad_row(row, number, number) :: row

  def pad_row(row, size, pad_value \\ 0)
  def pad_row(row, size, pad_value) when size > 0 do
    Enum.map(1..size, fn (_) -> pad_value end) ++ row
  end
  def pad_row(row, _, _), do: row


  @doc """
  Pads a row at the end given count of maybe given value (or 0)

  iex> Matrix.pad_row_after([1,2,3,4,5,6], 2)
  [1,2,3,4,5,6,0,0]
  iex> Matrix.pad_row_after([1,2,3,4,5,6], 2, 3)
  [1,2,3,4,5,6,3,3]
  """
  @spec pad_row_after(row, number) :: row
  @spec pad_row_after(row, number, number) :: row

  def pad_row_after(row, size, pad_value \\ 0)
  def pad_row_after(row, size, pad_value) when size > 0 do
    row ++ Enum.map(1..size, fn (_) -> pad_value end)
  end
  def pad_row_after(row, _, _), do: row
end
