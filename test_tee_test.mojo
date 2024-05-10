from teetest import TeeTest
from builtin._location import __call_location

var tests = TeeTest()

fn add_tests():
  tests.add_test(test1)
  tests.add_test(test2)
  tests.add_test(test3)
  tests.add_test(test4)
  tests.add_test(test_meta)

@always_inline
fn test1() raises -> (Bool, String):
  return True, String(__call_location())

@always_inline
fn test2() raises -> (Bool, String):
  return True, String(__call_location())

@always_inline
fn test3() raises -> (Bool, String):
  return True, String(__call_location())

@always_inline
fn test4() raises -> (Bool, String):
  return True, String(__call_location())

@always_inline
fn test_meta() raises -> (Bool, String):
  return tests.count() == 5, String(__call_location())

fn main():
  add_tests()
  tests.run_tests(False)
