from teetest import TeeTest
from ca_lib.stringlist import StringList

var tests = TeeTest()

fn add_tests():
  tests.add_test(test_list_append)
  tests.add_test(testList_iter)

fn test_list_append() raises -> Bool:
  var l = StringList()
  l += 1
  l += 2
  l += 3   
  print(str(l))
  return str(l) == "[1, 2, 3]"

fn testList_iter() raises -> Bool:
  var l = StringList()
  l += 1
  l += 2
  l += 3   
  var s = String("")
  for i in l:
    s += i
  return s == "123"

fn main():
	add_tests()
	tests.run_tests(False)
