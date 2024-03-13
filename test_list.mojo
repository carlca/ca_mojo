from teetest import TeeTest
from ca_lib.list import List
from ca_lib.list_utils import lu

fn test_list_append() raises -> (Bool, StringLiteral):
  var l = List[Int]()
  for i in range(1, 7):
    l += i
  return lu.ints_to_str(l) == "[1, 2, 3, 4, 5, 6]", __source_location().function_name

fn test_list_iter() raises -> (Bool, StringLiteral):
  var l = List[String]()
  for i in range(1, 7):
    l += String(i)
  var s: String = ""
  for i in l:
    s += i
  return s == "123456", __source_location().function_name

fn main():
  TeeTest(
    test_list_append,
    test_list_iter,
  ).run_tests(False)
