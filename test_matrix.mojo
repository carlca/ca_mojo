from teetest import TeeTest
from ca_lib.matrix import Matrix

var tests = TeeTest()

fn add_tests():
  tests.add_test(test_matrix_init)
  tests.add_test(test_matrix_add)

fn test_matrix_init() raises -> (Bool, StringLiteral):
  var m1 = Matrix("[[1.1, 1.1, 1.1], [2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4]]")
  var m2 = Matrix("[[1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1]]")
  return (m1.cols == 3 and m1.rows == 4 and m2.cols == 3 and m2.rows == 4, 
    __source_location().function_name)

fn test_matrix_add() raises -> (Bool, StringLiteral):
  var m1 = Matrix("[[1.1, 1.1, 1.1], [2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4]]")
  var m2 = Matrix("[[1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1], [1.1, 1.1, 1.1]]")
  var m3 = m1 + m2
  return (m3.string_to(1) == "[[2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4], [5.5, 5.5, 5.5]]",
    __source_location().function_name)

fn main():
  add_tests()
  tests.run_tests(False)
