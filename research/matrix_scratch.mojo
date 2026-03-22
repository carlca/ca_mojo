from python import PythonObject

def main():
  var col = "3.14159"
  # Convert the string col to a float64
  var p = PythonObject(col)
  var f = p.to_float64()
  print(f)
