from collections import List
from builtin.io import _printf as printf

fn function():
  pass

fn main():
  var l = List[Int]()
  print("length of list is ",len(l))
  l += 1
  l += 2
  l += 3
  function()
  print("length of list is ",len(l))
  printf["%d %d %d\n"](l[0], l[1], l[2])

  print(simdwidthof[DType.float64]() * 2)
  
    
