fn main() raises:
  var loc = "/Users/carlcaulkett/Code/Mojo/ca_mojo/test_float_utils.mojo:16:5"
  var file_name: String; var line: Int; var col: Int
  file_name, line, col = unpack_loc(loc)
  with open(file_name, "r") as f:
    var s = f.read()
    var code_lines = s.split("\n")
    print(code_lines[line - 1])

fn unpack_loc(loc: String) raises -> Tuple[String, Int, Int]:
  var parts = loc.split(":")
  return (parts[0], parts[1].__int__(), parts[2].__int__())



# Output of test
# 
# [Fri May 10 2024  8:12PM (BST+0100)]  (main) [*] 🐍 v3.12.1   
# ~/Code/Mojo/ca_mojo/ca_lib/research  mojo main.mojo
# /Users/carlcaulkett/Code/Mojo/ca_mojo/ca_lib/research/main.mojo:4:10
# /Users/carlcaulkett/Code/Mojo/ca_mojo/ca_lib/research/main.mojo:4:10