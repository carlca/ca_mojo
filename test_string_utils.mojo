from teetest import TeeTest
from ca_lib.string_utils import su
from collections import list 

fn test_string_split() raises -> (Bool, StringLiteral):
  var s = "a,b,c"
  var l = su.split(s, ",")
  return l[0] == "a" and l[1] == "b" and l[2] == "c",
    __source_location().function_name

fn test_string_split_empty() raises -> (Bool, StringLiteral):
  var s = ""
  return su.split(s, ",").size == 0,
    __source_location().function_name

fn main():
  TeeTest(
    test_string_split,
    test_string_split_empty,
  ).run_tests(False)
