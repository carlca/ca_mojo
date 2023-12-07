from teetest import TeeTest
from ca_lib.string_utils import su

var tests = TeeTest()

fn add_tests():
  tests.add_test(test_string_split)

fn test_string_split() raises -> Bool:
  let s = "a,b,c"
  let l = su.split(s, ",")
  return l[0] == "a" and l[1] == "b" and l[2] == "c"

fn main():
  add_tests()
  tests.run_tests()
