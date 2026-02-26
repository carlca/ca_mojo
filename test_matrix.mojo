from teetest.tee_test import TeeTest
from matrix import Matrix
from collections import list
from reflection import source_location, SourceLocation

@always_inline
fn test_matrix_init() raises -> Tuple[Bool, String]:
   var m1 = Matrix(content="[[1.1, 1.1, 1.1], [2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4]]")
   var m2 = Matrix(content="[[1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1]]")
   return m1.cols == 3 and m1.rows == 4 and m2.cols == 3 and m2.rows == 4,
      String(source_location())

@always_inline
fn test_matrix_add() raises -> Tuple[Bool, String]:
   var m1 = Matrix(content="[[1.1, 1.1, 1.1], [2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4]]")
   var m2 = Matrix(content="[[1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1]]")
   var m3 = m1 + m2
   return m3.string_to(1) == "[[2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4], [5.5, 5.5, 5.5]]",
      String(source_location())

fn main() raises:
   TeeTest(
      test_matrix_init,
      test_matrix_add
   ).run_tests(False)