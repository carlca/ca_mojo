from teetest.tee_test import TeeTest
from float_utils.floatutils import fu
from std.collections import list
from std.reflection import source_location, SourceLocation

@always_inline
def test_str_to_float_to_rounded_string() raises -> Tuple[Bool, String]:
   comptime pi_str = "3.1415926234534563"
   var pi = fu.str_to_float(pi_str)
   var assert1 = fu.format_float(pi, 5) == "3.14159"
   var assert2 = fu.format_float(pi, 6) == "3.141593"
   var assert3 = fu.format_float(pi, 7) == "3.1415926"
   return assert1 and assert2 and assert3, String(source_location())

@always_inline
def test_str_to_float_exact_values() raises -> Tuple[Bool, String]:
   var zero = fu.str_to_float("0.0")
   var fraction = fu.str_to_float("0.125")
   var mixed = fu.str_to_float("12.5")
   var assert1 = zero == 0.0
   var assert2 = fraction == 0.125
   var assert3 = mixed == 12.5
   return assert1 and assert2 and assert3, String(source_location())

@always_inline
def test_format_float_rounds_down() raises -> Tuple[Bool, String]:
   var assert1 = fu.format_float(3.1415926, 5) == "3.14159"
   var assert2 = fu.format_float(12.344, 2) == "12.34"
   return assert1 and assert2, String(source_location())

@always_inline
def test_format_float_rounds_up() raises -> Tuple[Bool, String]:
   var assert1 = fu.format_float(3.141586, 5) == "3.14159"
   var assert2 = fu.format_float(12.346, 2) == "12.35"
   return assert1 and assert2, String(source_location())

@always_inline
def test_format_float_preserves_trailing_zeroes() raises -> Tuple[Bool, String]:
   var assert1 = fu.format_float(2.5, 2) == "2.50"
   var assert2 = fu.format_float(4.0, 3) == "4.000"
   return assert1 and assert2, String(source_location())

def main() raises:
   TeeTest(
      test_str_to_float_to_rounded_string,
      test_str_to_float_exact_values,
      test_format_float_rounds_down,
      test_format_float_rounds_up,
      test_format_float_preserves_trailing_zeroes,
   ).run_tests(False)
