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

@always_inline
def test_string_split_multi_character_separator() raises -> Tuple[Bool, String]:
   var parts = su.split("alpha--beta--gamma", "--")
   return len(parts) == 3 and parts[0] == "alpha" and parts[1] == "beta" and parts[2] == "gamma",
      String(source_location())

@always_inline
def test_string_justification() raises -> Tuple[Bool, String]:
   return su.rjust("42", 5, "0") == "00042" and su.ljust("go", 4, ".") == "go.." and su.rjust("wide", 2) == "wide",
      String(source_location())

@always_inline
def test_string_endswith() raises -> Tuple[Bool, String]:
   return su.endswith("hello.mojo", ".mojo") and su.endswith("hello.mojo", "hello", 0, 5) and not su.endswith("hello.mojo", ".py"),
      String(source_location())

@always_inline
def test_string_trim() raises -> Tuple[Bool, String]:
   return su.trim("[[value]]", "[", "]") == "value" and su.trim("value", "[", "]") == "value" and su.trim("[]", "[", "]") == "",
      String(source_location())

@always_inline
def test_string_find() raises -> Tuple[Bool, String]:
   return su.find("one two one", "one") == 0 and su.find("one two one", "one", 1) == 8 and su.find("one two", "three") == -1,
      String(source_location())

@always_inline
def test_string_character_helpers() raises -> Tuple[Bool, String]:
   return su.remove_char("banana", "a") == "bnn" and su.count_char("banana", "a") == 3 and su.remove_char("banana", "ab") == "" and su.count_char("banana", "ab") == 0,
      String(source_location())

@always_inline
def test_string_substr_and_build_string() raises -> Tuple[Bool, String]:
   return su.substr("abcdef", 2, 3) == "cde" and su.substr("abcdef", 3) == "def" and su.build_string("x", 4) == "xxxx",
      String(source_location())

@always_inline
def test_split_to_strings() raises -> Tuple[Bool, String]:
   return su.split_to_strings("a,b,c", ",") == "a\nb\nc" and su.split_to_strings("", ",") == "",
      String(source_location())

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
