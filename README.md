# `ca_mojo`

A simple library written in pure Mojo🔥, the new faster, compiled, and stricter superset of Python,
by [Modular](https://modular.com).

Features include:

## `List`

Now superceded by `collections.List` in Mojo 24.2.

##  `test_list.mojo`

Not needed now

## `fu` - float utils

Contains:

- `fn str_to_float(s: String) raises -> Float64:`
- `fn format_float(f: Float64, dec_places: Int) -> String:`
  - `format_float` rounds up on half, so `format_float(3.14159, 4)` becomes `3.1416`.

### `test_float_utils.mojo`

Tests for `fu.str_to_float` and `fu.format_float`.

## `su` - string utils

Contains:

- `fn endswith(input_string: String, suffix: String, start: Int = 0, owned end: Int = -1) raises -> Bool:`
- `fn trim(s: String, leading: String, trailing: String) -> String:`
- `fn find(s: String, sub: String) -> Int:`
- `fn split(s: String, sep: String) -> List:`

### `test_string_utils.mojo`

Only tests for `fn split(s: String, sep: String) -> List:` at the moment.

## `Matrix`

A struct which represents a simple 2 dimensional matrix capable of storing Float64 numbers.

Contains many functions a lot of which have not even been tested casually, var alone by formal unit tests. Proceed with caution!

### `test_matrix.mojo`

Only tests for initialising from string...

- `var m1 = Matrix("[[1.1, 1.1, 1.1], [2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4]]")`
and for adding...
- `var m3 = m1 + m2`
and for converting back to string...
- `return m3.string_to(1) == "[[2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4], [5.5, 5.5, 5.5]]"`

## `TeeTest`

A modest test framework. For example...

```mojo
from teetest import TeeTest
from ca_lib.float_utils import fu

fn test_str_to_float_to_rounded_string() raises -> Tuple[Bool, StringLiteral]:
  alias pi_str = "3.1415926234534563"
  var pi = fu.str_to_float(pi_str)
  var assert1 = fu.format_float(pi, 5) == "3.14159"
  var assert2 = fu.format_float(pi, 6) == "3.141593"
  var assert3 = fu.format_float(pi, 7) == "3.1415926"
  return assert1 and assert2 and assert3,
    __source_location().function_name

fn main():
  TeeTest(
    test_str_to_float_to_rounded_string,
  ).run_tests()
```

## `preset_parser`

found in `ca_mojo/ca_lib/preset_parser/presetparser.mojo`

A proof-of-concept for using Mojo for binary file reading.

It parses the initial metadata found in a Bitwig `.bwpreset` file and displays it to the console.

To save to folder diving, you can run it from the root folder with...

Usage: `mojo parser.mojo <path-to-preset-file>`

Eg: `mojo parser.mojo ./Diffusion.bwpreset` 
or: `mojo parser.mojo ./Binaural_Organ_Device.bwpreset`

It uses some path related functions in `ca_mojo/ca_lib/sysutils`.