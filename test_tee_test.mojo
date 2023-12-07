from teetest import TeeTest

var tests = TeeTest()

fn add_tests():
  tests.add_test(test1)
  tests.add_test(test2)
  tests.add_test(test3)
  tests.add_test(test4)
  tests.add_test(test_meta)

fn test1() raises -> Bool:
  return True

fn test2() raises -> Bool:
  return True

fn test3() raises -> Bool:
  return True

fn test4() raises -> Bool:
  return True

fn test_meta() raises -> Bool:
  return tests.count() == 5

fn main():
  add_tests()
  tests.run_tests()

