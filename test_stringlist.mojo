from teetest import TeeTest
from ca_lib.stringlist import StringList

fn test_list_append() raises -> (Bool, StringLiteral):
  var l = StringList()
  l += 1
  l += 2
  l += 3
  return str(l) == "[1, 2, 3]",
    __source_location().function_name

fn testList_iter() raises -> (Bool, StringLiteral):
  var l = StringList()
  l += 1
  l += 2
  l += 3
  var s = String("")
  for i in l:
    s += str(i)
  return s == "123",
    __source_location().function_name

fn main():
  TeeTest(
    test_list_append,
    testList_iter,
  ).run_tests(False)
