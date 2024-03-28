fn main():
  var x = StaticTuple[4,Int](1,2,3,4)
  var x2 = [1, 1.9] #ListLiteral[Int,Float64]

  #StaticTuple can use dynamic values as index
  for i in range(4):
    print(x[i])

  #the index in the parameter cannot be a dynamic value(ex: for i in range.. wont work)
  print(x2.get[0,Int]())
  print(x2.get[1,Float64]())
