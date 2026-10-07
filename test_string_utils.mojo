from teetest.tee_test import TeeTest
from string_utils.stringutils import su
from std.collections import list
from std.reflection import source_location, SourceLocation

@always_inline
def test_string_split() raises -> Tuple[Bool, String]:
   var s = "a,b,c"
   var l = su.split(s, ",")
   var assert1 = l[0] == "a"
   var assert2 = l[1] == "b"
   var assert3 = l[2] == "c"
   return assert1 and assert2 and assert3, String(source_location())

@always_inline
def test_string_split_empty() raises -> Tuple[Bool, String]:
   var s = ""
   var assert1 = len(su.split(s, ",")) == 0
   return assert1, String(source_location())

@always_inline
def test_string_split_multi_character_separator() raises -> Tuple[Bool, String]:
   var parts = su.split("alpha--beta--gamma", "--")
   var assert1 = len(parts) == 3
   var assert2 = parts[0] == "alpha"
   var assert3 = parts[1] == "beta"
   var assert4 = parts[2] == "gamma"
   return assert1 and assert2 and assert3 and assert4, String(source_location())

@always_inline
def test_string_justification() raises -> Tuple[Bool, String]:
   var assert1 = su.rjust("42", 5, "0") == "00042"
   var assert2 = su.ljust("go", 4, ".") == "go.."
   var assert3 = su.rjust("wide", 2) == "wide"
   return assert1 and assert2 and assert3, String(source_location())

@always_inline
def test_string_endswith() raises -> Tuple[Bool, String]:
   var assert1 = su.endswith("hello.mojo", ".mojo")
   var assert2 = su.endswith("hello.mojo", "hello", 0, 5)
   var assert3 = not su.endswith("hello.mojo", ".py")
   return assert1 and assert2 and assert3, String(source_location())

@always_inline
def test_string_trim() raises -> Tuple[Bool, String]:
   var assert1 = su.trim("[[value]]", "[", "]") == "value"
   var assert2 = su.trim("value", "[", "]") == "value"
   var assert3 = su.trim("[]", "[", "]") == ""
   return assert1 and assert2 and assert3, String(source_location())

@always_inline
def test_string_find() raises -> Tuple[Bool, String]:
   var assert1 = su.find("one two one", "one") == 0
   var assert2 = su.find("one two one", "one", 1) == 8
   var assert3 = su.find("one two", "three") == -1
   return assert1 and assert2 and assert3, String(source_location())

@always_inline
def test_string_character_helpers() raises -> Tuple[Bool, String]:
   var assert1 = su.remove_char("banana", "a") == "bnn"
   var assert2 = su.count_char("banana", "a") == 3
   var assert3 = su.remove_char("banana", "ab") == ""
   var assert4 = su.count_char("banana", "ab") == 0
   return assert1 and assert2 and assert3 and assert4, String(source_location())

@always_inline
def test_string_substr_and_build_string() raises -> Tuple[Bool, String]:
   var assert1 = su.substr("abcdef", 2, 3) == "cde"
   var assert2 = su.substr("abcdef", 3) == "def"
   var assert3 = su.build_string("x", 4) == "xxxx"
   return assert1 and assert2 and assert3, String(source_location())

@always_inline
def test_split_to_strings() raises -> Tuple[Bool, String]:
   var assert1 = su.split_to_strings("a,b,c", ",") == "a\nb\nc"
   var assert2 = su.split_to_strings("", ",") == ""
   return assert1 and assert2, String(source_location())

def main() raises:
   TeeTest(
      test_string_split,
      test_string_split_empty,
      test_string_split_multi_character_separator,
      test_string_justification,
      test_string_endswith,
      test_string_trim,
      test_string_find,
      test_string_character_helpers,
      test_string_substr_and_build_string,
      test_split_to_strings,
   ).run_tests(False)
