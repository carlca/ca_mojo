from teetest import TeeTest
from ca_lib.string_utils import su
from ca_lib.stringlist import StringList

var tests = TeeTest()

fn add_tests():
  tests.add_test(test_string_split)
  tests.add_test(test_string_split_empty)

fn test_string_split() raises -> Bool:
  var s = "a,b,c"
  var l = su.split(s, ",")
  return l[0] == "a" and l[1] == "b" and l[2] == "c"

fn test_string_split_empty() raises -> Bool:
  var s = ""
  return su.split(s, ",") == StringList()

fn main():
  add_tests()
  tests.run_tests()
