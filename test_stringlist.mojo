from teetest import TeeTest
from ca_lib.stringlist import StringList

var tests = TeeTest()

fn add_tests():
  tests.add_test(test_list_append)
  tests.add_test(testList_iter)

fn test_list_append() raises -> (Bool, StringLiteral):
  var l = StringList()
  l += 1
  l += 2
  l += 3   
  return (str(l) == "[1, 2, 3]", __source_location().function_name)

fn testList_iter() raises -> (Bool, StringLiteral):
  var l = StringList()
  l += 1
  l += 2
  l += 3   
  var s = String("")
  for i in l:
    s += str(i)
  return (s == "123", __source_location().function_name)

fn main():
	add_tests()
	tests.run_tests(False)
