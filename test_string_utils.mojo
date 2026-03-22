from teetest.tee_test import TeeTest
from string_utils.stringutils import su
from std.collections import list
from std.reflection import source_location, SourceLocation

@always_inline
def test_string_split() raises -> Tuple[Bool, String]:
   var s = "a,b,c"
   var l = su.split(s, ",")
   return l[0] == "a" and l[1] == "b" and l[2] == "c",
      String(source_location())

@always_inline
def test_string_split_empty() raises -> Tuple[Bool, String]:
   var s = ""
   return len(su.split(s, ",")) == 0,
      String(source_location())

def main() raises:
   TeeTest(
      test_string_split,
      test_string_split_empty,
   ).run_tests(False)
