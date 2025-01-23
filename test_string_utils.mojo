from ca_lib.teetest.tee_test import TeeTest
from ca_lib.string_utils.stringutils import su
from collections import list
from builtin._location import __call_location

@always_inline
fn test_string_split() raises -> (Bool, String):
  var s = "a,b,c"
  var l = su.split(s, ",")
  return l[0] == "a" and l[1] == "b" and l[2] == "c",
    String(__call_location())

@always_inline
fn test_string_split_empty() raises -> (Bool, String):
  var s = ""
  return su.split(s, ",").size == 0,
    String(__call_location())

fn main() raises:
  TeeTest(
    test_string_split,
    test_string_split_empty,
  ).run_tests(False)
