from teetest import TeeTest
from ca_lib.matrix import Matrix
from builtin._location import __call_location

@always_inline
fn test_matrix_init() raises -> (Bool, String):
  var m1 = Matrix("[[1.1, 1.1, 1.1], [2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4]]")
  var m2 = Matrix("[[1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1]]")
  return m1.cols == 3 and m1.rows == 4 and m2.cols == 3 and m2.rows == 4,
    str(__call_location())

@always_inline
fn test_matrix_add() raises -> (Bool, String):
  var m1 = Matrix("[[1.1, 1.1, 1.1], [2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4]]")
  var m2 = Matrix("[[1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1]]")
  var m3 = m1 + m2
  return m3.string_to(1) == "[[2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4], [5.5, 5.5, 5.5]]",
    str(__call_location())

fn main() raises:
  TeeTest(
    test_matrix_init,
    test_matrix_add
  ).run_tests(False)
