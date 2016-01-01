defmodule MatrixTest do
  use ExUnit.Case
  doctest Matrix

  test "#num_columns returns the number of columns of that matrix" do
    assert 2 == Matrix.num_columns([[1,2],[3,4]])
    assert 3 == Matrix.num_columns([[1,2,3],[3,4,5]])
    assert 6 == Matrix.num_columns([[1,2,3,6,7,8],[3,4,5,3,4,6]])
  end

  test "#num_rows returns the number of rows of that matrix" do
    assert 2 == Matrix.num_rows([[1,2],[3,4]])
    assert 2 == Matrix.num_rows([[1,2,3],[3,4,5]])
    assert 3 == Matrix.num_rows([[1,2,3,6,7,8],[3,4,5,3,4,6],[3,4,4,4,4,6]])
  end

  test "#size returns the rows and columns of given matrix" do
    assert {2, 2} == Matrix.size([[1,2],[3,4]])
    assert {3, 2} == Matrix.size([[1,2,3],[3,4,5]])
    assert {6, 3} == Matrix.size([[1,2,3,6,7,8],[3,4,5,3,4,6],[3,4,4,4,4,6]])
  end

  test "#rotate_right rotates matrix to the right" do
    matrix = [[1,2],[3,4]]
    rotated_matrix = [[3,1],[4,2]]

    assert Matrix.rotate_right(matrix) == rotated_matrix

    matrix3 = [[1,2,3],[4,5,6],[7,8,9]]
    rotated_matrix3 = [[7,4,1],[8,5,2],[9,6,3]]

    assert Matrix.rotate_right(matrix3) == rotated_matrix3

    matrix23 = [[1,2,3],[4,5,6]]
    rotated_matrix23 = [[4,1],[5,2],[6,3]]

    assert Matrix.rotate_right(matrix23) == rotated_matrix23
  end

  test "#rotate_left rotates matrix to the left" do
    matrix = [[1,2],[3,4]]
    rotated_matrix = [[2,4],[1,3]]

    assert Matrix.rotate_left(matrix) == rotated_matrix

    matrix3 = [[7,4,1],[8,5,2],[9,6,3]]
    rotated_matrix3 = [[1,2,3],[4,5,6],[7,8,9]]

    assert Matrix.rotate_left(matrix3) == rotated_matrix3

    matrix23 = [[4,1],[5,2],[6,3]]
    rotated_matrix23 = [[1,2,3],[4,5,6]]

    assert Matrix.rotate_left(matrix23) == rotated_matrix23
  end

  test "#create_matrix creates a zero matrix with given dimensions" do
    assert Matrix.create_matrix(3, 4) == [
      [0,0,0],
      [0,0,0],
      [0,0,0],
      [0,0,0]
    ]
  end

  test "#any? returns true if method returns true once" do
    assert Matrix.any?([[0,0], [0,1]], fn x -> x==0 end) == true
    assert Matrix.any?([[0,0], [0,1]], fn x -> x==1 end) == true
    assert Matrix.any?([[0,0], [0,1]], fn x -> x==2 end) == false
  end

  test "#zip creates new matrix of tuples" do
    m1 = [[1,3]]
    m2 = [[1,2]]
    assert Matrix.zip(m1, m2) == [[{1,1}, {3,2}]]
  end

  test "#zip only works for matrices of same size" do
    m1 = [[1]]
    m2 = [[1,2]]
    assert Matrix.zip(m1, m2) == {:error, :NOT_SAME_SIZE}
  end

  test "#pad_row does nothing if size is 0" do
    assert Matrix.pad_row([1,2,3], 0) == [1,2,3]
  end

  test "#pad_row does something if size is 1" do
    assert Matrix.pad_row([1,2,3], 1) == [0, 1,2,3]
  end

  test "#pad_row_after does nothing if size is 0" do
    assert Matrix.pad_row_after([1,2,3], 0) == [1,2,3]
  end

  test "#pad_row_after does something if size is 1" do
    assert Matrix.pad_row_after([1,2,3], 1) == [1,2,3,0]
  end

  test "#create_matrix can create a matrix with given dimensions and all threes" do
    assert Matrix.create_matrix(2, 3, 3) == [
      [3,3],
      [3,3],
      [3,3]
    ]
  end

  test "#remove_row removes specified row" do
    init_matrix = [
      [0,1,0],
      [0,2,0],
      [0,3,0],
      [0,4,0]
    ]

    assert Matrix.remove_row(init_matrix, 2) == [
      [0,1,0],
      [0,2,0],
      [0,4,0]
    ]
  end


  test "#replace_row replaces specified row with another one" do
    init_matrix = [
      [0,1,0],
      [0,2,0],
      [0,3,0],
      [0,4,0]
    ]

    assert Matrix.replace_row(init_matrix, 2, [6,6,6]) == [
      [0,1,0],
      [0,2,0],
      [6,6,6],
      [0,4,0]
    ]
  end

  test "#replace_rows replaces specified rows with different ones" do
    init_matrix = [
      [0,1,0],
      [0,2,0],
      [0,3,0],
      [0,4,0]
    ]

    assert Matrix.replace_rows(init_matrix, 1, [[6,6,6], [6,6,6]]) == [
      [0,1,0],
      [6,6,6],
      [6,6,6],
      [0,4,0]
    ]
  end

  test "#insert_row adds given row to specific point" do
    init_matrix = [
      [0,1,0],
      [0,2,0],
      [0,3,0],
      [0,4,0]
    ]

    assert Matrix.insert_row(init_matrix, 2, [6,6,6]) == [
      [0,1,0],
      [0,2,0],
      [6,6,6],
      [0,3,0],
      [0,4,0]
    ]
  end

  test "#map calls given callback on every item in the matrix and creates a new one" do
    init_matrix = [
      [0,1,0],
      [0,2,0],
      [0,3,0]
    ]

    assert Matrix.map(init_matrix, fn(x) -> x*3 end) == [
      [0,3,0],
      [0,6,0],
      [0,9,0]
    ]
  end

  test "#map can also be used with index" do
    init_matrix = [
      [0,1,0],
      [0,2,0],
      [0,3,0]
    ]

    assert Matrix.map(init_matrix, fn(x, index) -> x+index end) == [
      [0,1,0],
      [1,3,1],
      [2,5,2]
    ]
  end

  test "#map_rows maps through each row" do
    init_matrix = [
      [0,1,0],
      [0,2,0],
      [0,3,0]
    ]

    assert Matrix.map_rows(init_matrix, fn(row) -> [9|row] end) == [
      [9,0,1,0],
      [9,0,2,0],
      [9,0,3,0]
    ]
  end

  test "#map_rows can have an index" do
    init_matrix = [
      [0,1,0],
      [0,2,0],
      [0,3,0]
    ]

    assert Matrix.map_rows(init_matrix, fn(row, index) -> [index|row] end) == [
      [0,0,1,0],
      [1,0,2,0],
      [2,0,3,0]
    ]
  end

  test "#multiply returns error for not same sized matrices" do
    matrix_a = [
      [0,1,0],
      [0,2,0],
      [0,3,0]
    ]
    matrix_b = [
      [0,1,0],
      [0,3,0]
    ]

    assert Matrix.multiply(matrix_a, matrix_b) == {:error, :NOT_SAME_SIZE}
  end

  test "#add returns error for not same sized matrices" do
    matrix_a = [
      [0,1],
      [0,3]
    ]
    matrix_b = [
      [0,1,0],
      [0,3,0]
    ]

    assert Matrix.add(matrix_a, matrix_b) == {:error, :NOT_SAME_SIZE}
  end

  test "#slice slices out a smaller matrix out of a bigger one" do
    matrix = [
      [0,0,1,2],
      [0,0,2,3],
      [0,3,0,4],
      [0,4,5,0]
    ]

    assert Matrix.slice(matrix, 1,0, 2,2) == [
      [0,1],
      [0,2]
    ]
    assert Matrix.slice(matrix, 2,2, 3,3) == [
      [0,4],
      [5,0]
    ]
  end


  # TODO: add guards and stuff for everything
end
