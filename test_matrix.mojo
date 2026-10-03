from teetest.tee_test import TeeTest
from matrix import Matrix
from std.collections import list
from std.reflection import source_location, SourceLocation

@always_inline
def test_matrix_init() raises -> Tuple[Bool, String]:
   var m1 = Matrix(content="[[1.1, 1.1, 1.1], [2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4]]")
   var m2 = Matrix(content="[[1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1]]")
   return m1.cols == 3 and m1.rows == 4 and m2.cols == 3 and m2.rows == 4,
      String(source_location())

@always_inline
def test_matrix_add() raises -> Tuple[Bool, String]:
   var m1 = Matrix(content="[[1.1, 1.1, 1.1], [2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4]]")
   var m2 = Matrix(content="[[1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1]]")
   var m3 = m1 + m2
   return m3.string_to(1) == "[[2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4], [5.5, 5.5, 5.5]]",
      String(source_location())

@always_inline
def test_matrix_zero_init_and_indexing() raises -> Tuple[Bool, String]:
   var matrix = Matrix(rows=2, cols=3)
   matrix[0, 1] = 2.5
   matrix[1, 2] = -4.0
   return matrix.total_items == 6 and matrix.get_shape() == (2, 3) and matrix[0, 0] == 0.0 and matrix[0, 1] == 2.5 and matrix[1, 2] == -4.0,
      String(source_location())

@always_inline
def test_matrix_arithmetic() raises -> Tuple[Bool, String]:
   var left = Matrix(content="[[1.0, 2.0], [3.0, 4.0]]")
   var right = Matrix(content="[[5.0, 6.0], [7.0, 8.0]]")
   var difference = right - left
   var product = left * right
   var quotient = right / left
   return difference == Matrix(content="[[4.0, 4.0], [4.0, 4.0]]") and product == Matrix(content="[[19.0, 22.0], [43.0, 50.0]]") and quotient == Matrix(content="[[5.0, 3.0], [2.3333333333333335, 2.0]]"),
      String(source_location())

@always_inline
def test_matrix_scalar_arithmetic_and_negation() raises -> Tuple[Bool, String]:
   var matrix = Matrix(content="[[1.0, 2.0], [3.0, 4.0]]")
   return matrix + 1.0 == Matrix(content="[[2.0, 3.0], [4.0, 5.0]]") and matrix - 1.0 == Matrix(content="[[0.0, 1.0], [2.0, 3.0]]") and matrix * 2.0 == Matrix(content="[[2.0, 4.0], [6.0, 8.0]]") and matrix / 2.0 == Matrix(content="[[0.5, 1.0], [1.5, 2.0]]") and -matrix == Matrix(content="[[-1.0, -2.0], [-3.0, -4.0]]"),
      String(source_location())

@always_inline
def test_matrix_transpose() raises -> Tuple[Bool, String]:
   var matrix = Matrix(content="[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]")
   var transposed = matrix.transpose()
   return transposed.get_shape() == (3, 2) and transposed == Matrix(content="[[1.0, 4.0], [2.0, 5.0], [3.0, 6.0]]"),
      String(source_location())

@always_inline
def test_matrix_rows_and_columns() raises -> Tuple[Bool, String]:
   var matrix = Matrix(content="[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]")
   var row = matrix.get_row(1)
   var col = matrix.get_col(0)
   matrix.set_row(0, Matrix(content="[[7.0, 8.0, 9.0]]"))
   matrix.set_col(2, Matrix(content="[[10.0], [11.0]]"))
   return row == Matrix(content="[[4.0, 5.0, 6.0]]") and col == Matrix(content="[[1.0], [4.0]]") and matrix == Matrix(content="[[7.0, 8.0, 10.0], [4.0, 5.0, 11.0]]"),
      String(source_location())

@always_inline
def test_matrix_slices() raises -> Tuple[Bool, String]:
   var matrix = Matrix(content="[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]]")
   var middle = matrix.get_slice(0, 1, 1, 2)
   matrix.set_slice(1, 2, 0, 1, Matrix(content="[[10.0, 11.0], [12.0, 13.0]]"))
   return middle == Matrix(content="[[2.0, 3.0], [5.0, 6.0]]") and matrix == Matrix(content="[[1.0, 2.0, 3.0], [10.0, 11.0, 6.0], [12.0, 13.0, 9.0]]"),
      String(source_location())

def main() raises:
   TeeTest(
      test_matrix_init,
      test_matrix_add,
      test_matrix_zero_init_and_indexing,
      test_matrix_arithmetic,
      test_matrix_scalar_arithmetic_and_negation,
      test_matrix_transpose,
      test_matrix_rows_and_columns,
      test_matrix_slices,
   ).run_tests(False)