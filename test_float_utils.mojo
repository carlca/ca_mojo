from teetest import TeeTest
from ca_lib.float_utils import fu

fn test_str_to_float_to_rounded_string() raises -> (Bool, StringLiteral):
  alias pi_str = "3.1415926234534563"
  var pi = fu.str_to_float(pi_str)
  var assert1 = fu.format_float(pi, 5) == "3.14159"
  var assert2 = fu.format_float(pi, 6) == "3.141593"
  var assert3 = fu.format_float(pi, 7) == "3.1415926"
  return assert1 and assert2 and assert3, __source_location().function_name

fn main():
  TeeTest(
    test_str_to_float_to_rounded_string,
  ).run_tests(False)
