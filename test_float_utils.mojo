from teetest.tee_test import TeeTest
from float_utils.floatutils import fu
from collections import list
from builtin._location import __call_location

@always_inline
fn test_str_to_float_to_rounded_string() raises -> (Bool, String):
   alias pi_str = "3.1415926234534563"
   var pi = fu.str_to_float(pi_str)
   var assert1 = fu.format_float(pi, 5) == "3.14159"
   var assert2 = fu.format_float(pi, 6) == "3.141593"
   var assert3 = fu.format_float(pi, 7) == "3.1415926"
   return assert1 and assert2 and assert3, String(__call_location())

fn main() raises:
   TeeTest(
      test_str_to_float_to_rounded_string,
   ).run_tests(False)
