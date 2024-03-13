from teetest import TeeTest

var tests = TeeTest()

fn add_tests():
  tests.add_test(test1)
  tests.add_test(test2)
  tests.add_test(test3)
  tests.add_test(test4)
  tests.add_test(test_meta)

fn test1() raises -> (Bool, StringLiteral):
  return True, __source_location().function_name

fn test2() raises -> (Bool, StringLiteral):
  return True, __source_location().function_name

fn test3() raises -> (Bool, StringLiteral):
  return True, __source_location().function_name

fn test4() raises -> (Bool, StringLiteral):
  return True, __source_location().function_name

fn test_meta() raises -> (Bool, StringLiteral):
  return tests.count() == 5, __source_location().function_name

fn main():
  add_tests()
  tests.run_tests(False)
