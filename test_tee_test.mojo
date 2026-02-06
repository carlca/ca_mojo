from teetest.tee_test import TeeTest
from reflection import source_location, SourceLocation

@always_inline
fn test1() raises -> Tuple[Bool, String]:
   return True, String(source_location())

@always_inline
fn test2() raises -> Tuple[Bool, String]:
   return True, String(source_location())

@always_inline
fn test3() raises -> Tuple[Bool, String]:
   return True, String(source_location())

@always_inline
fn test4() raises -> Tuple[Bool, String]:
   return True, String(source_location())

fn main() raises:
   TeeTest(
      test1,
      test2,
      test3,
      test4,
   ).run_tests(False)