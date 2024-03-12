from matrix import Matrix
from python import Python
from python import PythonObject
from list import List 

import string_utils as su
import float_utils as fu

fn main() raises:
  var s1: String = "[[1.1, 1.1, 1.1], [2.2, 2.2, 2.2], [3.3, 3.3, 3.3], [4.4, 4.4, 4.4]]"
  var mm = Matrix(s1)
  print("mm.print()")
  var s2: String = mm.string_to(1)
  if s1 == s2:
    print("s1 = s2!")
  
  print("---------")

  print("")

  print("split + str")
  var spl = su.split(s1, '], [')
  print (spl.str())

  print("")

  print("split + __str__")
  spl = su.split(s1, '], [')
  print (spl.__str__())

  print("")

  print("split_to_strings")
  var sps = su.split_to_strings(s1, '], [')
  print (sps)

  print("")
  print("remove_spaces")
  var sr = su.remove_char("['1.1, 1.1, 1.1', '2.2, 2.2, 2.2', '3.3, 3.3, 3.3', '4.4, 4.4, 4.4']", " ")
  print(sr)
  sr = su.trim(sr, "[", "]")
  print(sr)
  sr = su.trim(sr, "'", "'")
  print(sr)
  print("")	
  
  spl = su.split(sr, "','")
  
  print("Using spl.str():")
  print(spl.str())
  print("")	

  print("Using 'for sl in spl':")
  for sl in spl:
    print(sl)

  print ("It works!\n")

  print("Parsing each row:")
  var first = spl[0]
  print(first)
  print(su.count_char(first, ','))
  print("")

  
  

