from teetest.tee_test import TeeTest
from builtin._location import __call_location

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

fn main() raises:
   TeeTest(
      test1,
      test2,
      test3,
      test4,
   ).run_tests(False)