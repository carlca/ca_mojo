

fn main() raises:
  var v = DynamicVector[UInt8]()
  v.push_back(4)
  v.push_back(0)
  v.push_back(0)
  v.push_back(0)
  print(vec_to_string(v))

fn vec_to_string(data: DynamicVector[UInt8]) raises -> String:
  var result = String()
  for i in range(0, len(data)):
    if data[i] == 0x00:
      break
    result += chr(data[i].to_int())
  return result
