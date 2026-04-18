from teetest.tee_test import TeeTest
from std.reflection import source_location, SourceLocation

@always_inline
def test1() raises -> Tuple[Bool, String]:
   return True, String(source_location())

@always_inline
def test2() raises -> Tuple[Bool, String]:
   return False, String(source_location())

@always_inline
def test3() raises -> Tuple[Bool, String]:
   return True, String(source_location())

@always_inline
def test4() raises -> Tuple[Bool, String]:
   return False, String(source_location())

def main() raises:
   TeeTest(
      test1,
      test2,
      test3,
      test4,
   ).run_tests(False)