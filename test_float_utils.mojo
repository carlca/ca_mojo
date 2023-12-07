from teetest import TeeTest
from ca_lib.float_utils import fu

var tests = TeeTest()

fn add_tests():
  tests.add_test(test_str_to_float_to_rounded_string)

fn test_str_to_float_to_rounded_string() raises -> Bool:
    let pi_str = "3.1415926234534563"
    let pi = fu.str_to_float(pi_str)
    let assert1 = fu.format_float(pi, 5) == "3.14159"
    let assert2 = fu.format_float(pi, 6) == "3.141593"
    let assert3 = fu.format_float(pi, 7) == "3.1415926"
    return assert1 and assert2 and assert3

fn main():
  add_tests()
  tests.run_tests()

