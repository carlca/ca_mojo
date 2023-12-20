# ca_mojo
A simple library writen in pure Mojo, the new faster, compiled, and stricter superset of Python,
by [Modular](https://modular.com)🔥

Features include:
 
### List 
 A struct which implements list of Strings with:
```
var l = List() 
  l += 1 
  l += 2   
  l += 3   
  var s = String("")
  for i in l:
    s += i
  return s == "123"
```

### test_list.mojo
Tests for List struct. Needs greater list coverage

### fu - float utils
Contains:
- ```fn str_to_float(s: String) raises -> Float64:```
- ```fn format_float(f: Float64, dec_places: Int) -> String:```
`format_float` rounds up on half, so `format_float(3.14159, 4)` becomes `3.1416`.

### test_float_utils.mojo
Tests for `fu.str_to_float` and `fu.format_float`.

### su - string utils
`su` has many functions, including:
- ```fn endswith(input_string: String, suffix: String, start: Int = 0, owned end: Int = -1) raises -> Bool:```
- ```fn trim(s: String, leading: String, trailing: String) -> String:```
- ```fn find(s: String, sub: String) -> Int:```
- ```fn split(s: String, sep: String) -> List:```

### test_string_utils.mojo
Only tests for `fn split(s: String, sep: String) -> List:` at the moment.

###  Matrix 
A struct which represents a simple 2 dimensional matrix capable of storing Float64 numbers. 

Contains many functions a lot of which have not even been tested casually, let alone by formal unit tests. Proceed with caution!

### test_matrix.mojo
Only tests for initialising from string...
- ```let m1 = Matrix("[[1.1, 1.1, 1.1], [2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4]]")```
and for adding...
- ```let m3 = m1 + m2```
and for converting back to string...
- ```return m3.string_to(1) == "[[2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4], [5.5, 5.5, 5.5]]"```

### TeeTest 
A modest test framework. For example...
```
from teetest import TeeTest
from ca_lib.float_utils import fu

var tests = TeeTest()

fn add_tests():
  tests.add_test(test_str_to_float_to_rounded_string)

fn test_str_to_float_to_rounded_string() raises -> Bool:
    let pi_str = "3.1415926234534563"
    let pi = fu.str_to_float(pi_str)
    let assert1 = fu.format_float(pi, 5) == "3.14159"
    let assert2 = fu.format_float(pi, 6) == "3.141593"
    let assert3 = fu.format_float(pi, 7) == "3.1415926"
    return assert1 and assert2 and assert3

fn main():
  add_tests()
  tests.run_tests()
```
 Possibly notable for the use of `alias` to ease the adoption of the changes to `Dynamic Array` in `Mojo v0.6.0` 😉
 ```from utils.vector import _OldDynamicVector

alias DynamicVector = _OldDynamicVector
alias TestFn = fn() raises -> Bool 

var tests: DynamicVector[TestFn] = DynamicVector[TestFn]()
```# ca_mojo
# ca_mojo
# ca_mojo
