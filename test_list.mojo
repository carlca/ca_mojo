from teetest import TeeTest
from ca_lib.list import List
from ca_lib.list_utils import lu

var tests = TeeTest()

fn add_tests():
  tests.add_test(test_list_append)
  tests.add_test(testList_iter)

fn test_list_append() raises -> Bool:
  var l = List[Int]()
  l += 1
  l += 2
  l += 3   
  l += 4
  l += 5
  l += 6   
  print(lu.ints_to_str(l))
  return lu.ints_to_str(l) == "[1, 2, 3, 4, 5, 6]"

fn testList_iter() raises -> Bool:
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
  return s == "123456"

fn main():
	add_tests()
	tests.run_tests(False)
