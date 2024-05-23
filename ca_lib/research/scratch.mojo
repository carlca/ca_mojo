from collections import List
from builtin.io import _printf as printf

fn main() raises:
  var v = List[UInt8]()
  v.push_back(16)
  v.push_back(0)
  v.push_back(0)
  v.push_back(0)
  print(vec_to_hex(v))
  var size: UInt32 = 0
  for i in range(0, 4):
    size |= v[i].cast[DType.uint32]() << ((3 - i) * 8)
  printf("dec: %d\n", size)
  printf("hex: %x", size)

fn vec_to_string(data: List[UInt8]) raises -> String:
  var result = String()
  for i in range(0, len(data)):
    if data[i] == 0x00:
      break
    result += chr(data[i].to_int())
  return result

fn vec_to_hex(data: List[UInt8]) raises -> String:
  var result = String()
  for i in range(0, len(data)):
    result += hex(data[i], False)
  return result

fn hex(x: UInt8, top_and_tail: Bool) -> String:
  alias hex_table: String = "0123456789abcdef"
  if top_and_tail:
    return "0x" + hex_table[(x >> 4).to_int()] + hex_table[(x & 0xF).to_int()] + " "
  return hex_table[(x >> 4).to_int()] + hex_table[(x & 0xF).to_int()]
