from teetest import TeeTest
from ca_lib.list import List
from ca_lib.list_utils import lu

var tests = TeeTest()

fn add_tests():
  tests.add_test(test_list_append)
  tests.add_test(test_list_iter)

fn test_list_append() raises -> (Bool, StringLiteral):
  var l = List[Int]()
  l += 1
  l += 2
  l += 3   
  l += 4
  l += 5
  l += 6   
  return (lu.ints_to_str(l) == "[1, 2, 3, 4, 5, 6]", __source_location().function_name)

fn test_list_iter() raises -> (Bool, StringLiteral):
  var l = List[String]()
  l += 1
  l += 2
  l += 3   
  l += 4
  l += 5
  l += 6   
  var s = String("")

  for i in l:
    s += i
  return (s == "123456", __source_location().function_name)

fn main():
	add_tests()
	tests.run_tests(False)
