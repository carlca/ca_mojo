from python import PythonObject

fn main():
  let col = "3.14159"
  # Convert the string col to a float64
  let p = PythonObject(col)
  let f = p.to_float64()
  print(f)
