from builtin._location import __call_location, _SourceLocation

fn main():
  test_fn()   # <== Reports this location!

@always_inline("nodebug")
fn test_fn():
  var call_loc = __call_location()
  print(call_loc)
  test_print(call_loc)

fn test_print(loc: String):
  print(loc)

  
# Output of test
# 
# [Fri May 10 2024  8:12PM (BST+0100)]  (main) [*] 🐍 v3.12.1   
# ~/Code/Mojo/ca_mojo/ca_lib/research  mojo main.mojo
# /Users/carlcaulkett/Code/Mojo/ca_mojo/ca_lib/research/main.mojo:4:10
# /Users/carlcaulkett/Code/Mojo/ca_mojo/ca_lib/research/main.mojo:4:10