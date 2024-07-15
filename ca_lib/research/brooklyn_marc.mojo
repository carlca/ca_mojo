fn my_function(x: Int):
  var z: Float32
  if x != 0:
    if x == 0:
      z = 1.0
    else:
      z = foo()
    print(z)

fn foo() -> String:
  return "hello"

fn main():
  my_function(0) 
