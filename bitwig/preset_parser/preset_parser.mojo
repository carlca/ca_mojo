from tensor import Tensor, TensorSpec, TensorShape
from ca_lib.stringlist import StringList
from builtin.io import _printf as printf
from ca_lib.sys_utils import sysutils 
from math.bit import bswap

@value
struct ReadResult(StringableRaising):
  var pos: Int
  var size: Int
  var data: DynamicVector[UInt8]

  fn __str__(self) raises -> String:
    var result = "pos: " + String(self.pos) + " size: " + String(self.size) + " data: [" 
    for i in range(0, self.data.__len__()):
      result += String(self.data[i]) + " "
    result += "]"  
    return result

@value
struct Parser:
  
  fn __init__(inout self) raises:
    pass

  fn process_preset(borrowed self, file_name: String, debug: Bool) raises:
    var pos: Int = 0x36

    var f = open(file_name, "r")
    while True:
      var result = self.read_key_and_value(f, pos, debug)
      pos = result.pos
      if result.size == 0: break
    f.close()

  fn read_key_and_value(borrowed self, f: FileHandle, inout pos: Int, debug: Bool) raises -> ReadResult:
    var skips = self.get_skip_size(f, pos)
    if debug:
      self.get_skip_size_debug(f, pos)
      print(String(skips) + " skips")
    pos += skips

    var result = self.read_next_size_and_chunk(f, pos)
    pos = result.pos
    var size = result.size
    var data = result.data
    if size == 0: return ReadResult(0, 0, DynamicVector[UInt8]())
    printf("[%s] ", self.vec_to_string(data))

    skips = self.get_skip_size(f, pos)
    if debug:
      self.get_skip_size_debug(f, pos)
      print(String(skips) + " skips")
    pos += skips

    result = self.read_next_size_and_chunk(f, pos)
    printf("%s\n", self.vec_to_string(result.data))
    return ReadResult(result.pos, result.size, DynamicVector[UInt8]())

  fn vec_to_string(self, data: DynamicVector[UInt8]) raises -> String:
    var result = String()
    for i in range(0, len(data)):
      if data[i] == 0x00:
        break
      result += chr(data[i].to_int())
    return result

  fn get_skip_size(borrowed self, f: FileHandle, inout pos: Int) raises -> Int:
    var bytes = self.read_from_file(f, pos, 32, True).data
    for i in range(0, bytes.__len__()):
      if bytes[i] >= 0x20 and (i == 5 or i == 8 or i == 13):
        return i - 4
    return 1

  fn get_skip_size_debug(borrowed self, f: FileHandle, inout pos: Int) raises:
    var bytes = self.read_from_file(f, pos, 32, True).data
    for b in range(0, bytes.__len__()):
      printf("%02x ", bytes[b])
    print()
    for b in range(0, bytes.__len__()):
      if bytes[b] >= 0x31:
        printf(".%c.", bytes[b])
      else:
        printf("   ")
    print()

  # Borrowed from @gabrieldemarmiesse :)
  fn hex(self, x: UInt8) -> String:
    alias hex_table: String = "0123456789abcdef"
    return "0x" + hex_table[(x >> 4).to_int()] + hex_table[(x & 0xF).to_int()]

  fn read_next_size_and_chunk(self, f: FileHandle, inout pos: Int) raises -> ReadResult:
    var int_chunk = self.read_int_chunk(f, pos);
    if (int_chunk.size == 0):
      return ReadResult(pos, 0, DynamicVector[UInt8]())
    return self.read_from_file(f, int_chunk.pos, int_chunk.size, True)
  
  fn read_int_chunk(self, f: FileHandle, inout pos: Int) raises -> ReadResult:
    var new_read = self.read_from_file(f, pos, 4, True)
    if new_read.data.size == 0:
      return ReadResult(0, 0, DynamicVector[UInt8]())
    pos = new_read.pos
    var size: UInt32 = 0
    for i in range(0, 4):
      size |= new_read.data[i].cast[DType.uint32]() << ((3 - i) * 8)
    # var ui32_ptr = Pointer[UInt8](new_read.data.data.value).bitcast[UInt32]()
    # var size = ui32_ptr[0]
    # _ = new_read.data
    return ReadResult(pos, size.to_int(), DynamicVector[UInt8]())

  fn print_byte_vector(self, data: DynamicVector[UInt8]) raises:
    for i in range(0, data.__len__()):
      printf("%02x ", data[i])
    print()

  fn read_from_file(self, f: FileHandle, pos: Int, size: Int, advance: Bool) raises -> ReadResult:
    var data = DynamicVector[UInt8]()
    try:
      _ = f.seek(pos)
    except:
      return ReadResult(0, 0, DynamicVector[UInt8]())
    # f.read_bytes forces the use of a SIMD[si64, 1] for `size`
    # and a Tensor[DType.int8] for the return type!
    var t_si8: Tensor[DType.int8] = f.read_bytes(size)
    var t_ui8: Tensor[DType.uint8] = t_si8.astype[DType.uint8]()
    for i in range(0, t_ui8.num_elements()):
      data.push_back(t_ui8[i]) 
    var increment = 0
    if advance: 
      increment = size
    return ReadResult(pos + increment, size, data)

fn main() raises:
  var args = sysutils.get_params()
  if args.len() == 0:
    print("Usage: mojo preset_parser <preset file>")
    return
  var filename = sysutils.get_app_path() + args[0]
  print("filemame: " + filename)
  print()
  var parser = Parser()
  parser.process_preset(filename, False)
  print()


  
