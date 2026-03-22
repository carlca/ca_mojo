def my_function(x: Int):
  var z: Float32
  if x != 0:
    if x == 0:
      z = 1.0
    else:
      z = foo()
    print(z)

def foo() -> String:
  return "hello"

def main():
  my_function(0) 
