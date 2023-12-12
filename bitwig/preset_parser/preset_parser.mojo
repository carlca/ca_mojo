from tensor import Tensor, TensorSpec, TensorShape
from ca_lib.stringlist import StringList
from builtin.io import _printf as printf
from ca_lib.sys_utils import sysutils 
# from memory.unsafe import Pointer, DTypePointer

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
    print("Processing preset: " + file_name)
    var pos: Int = 0x36

    var f = open(file_name, "rb")
    while True:
      let result = self.read_key_and_value(f, pos, debug)
      print(result.__str__())
      pos = result.pos
      if result.size == 0: break
    f.close()

  fn read_key_and_value(borrowed self, f: FileHandle, pos: Int, debug: Bool) raises -> ReadResult:
    var pos2 = pos
    printf("  pos2: %02x - %d\n", pos2, pos2) 
    var skips = self.get_skip_size(f, pos2)
    if debug:
      self.get_skip_size_debug(f, pos2)
      print(String(skips) + " skips")
    pos2 += skips

    var result = self.read_next_size_and_chunk(f, pos2)
    pos2 = result.pos
    let size = result.size
    let data = result.data
    if size == 0: return ReadResult(0, 0, DynamicVector[UInt8]())
    self.print_output("read_key_and_value - 1", pos2, size, data)

    skips = self.get_skip_size(f, pos2)
    if debug:
      self.get_skip_size_debug(f, pos2)
      print(String(skips) + " skips")
    pos2 += skips

    result = self.read_next_size_and_chunk(f, pos2)
    self.print_result("read_key_and_value - 2", result)
    print()
    return ReadResult(result.pos, result.size, DynamicVector[UInt8]())

  fn print_result(self, name: String, result: ReadResult) raises:
    self.print_output(name, result.pos, result.size, result.data)

  fn print_output(self, name: String, pos: Int, size: Int, data: DynamicVector[UInt8]) raises:
    printf(" name: %s\n", name) 
    printf("  pos: %02x - %d\n", pos, pos) 
    printf(" size: %02x - %d\n", size, size)
    print_no_newline(" data: ")
    print(self.vec_to_string(data))
    print()  

  fn vec_to_string(self, data: DynamicVector[UInt8]) raises -> String:
    var result = String()
    for i in range(0, len(data)):
      if data[i] == 0x00:
        break
      result += chr(data[i].to_int())
    return result

  fn get_skip_size(borrowed self, f: FileHandle, pos: Int) raises -> Int:
    let bytes = self.read_from_file(f, pos, 32, True).data
    for i in range(0, bytes.__len__()):
      if bytes[i] >= 0x20 and (i == 5 or i == 8 or i == 13):
        return i - 4
    return 1

  fn get_skip_size_debug(borrowed self, f: FileHandle, pos: Int) raises:
    let bytes = self.read_from_file(f, pos, 32, True).data
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

  fn read_next_size_and_chunk(self, f: FileHandle, pos: Int) raises -> ReadResult:
    let int_chunk = self.read_int_chunk(f, pos);
    if (int_chunk.size == 0):
      return ReadResult(pos, 0, DynamicVector[UInt8]())
    self.print_result("read_next_size_and_chunk - size", int_chunk)
    let chunk = self.read_from_file(f, int_chunk.pos, int_chunk.size, True)
    self.print_result("read_next_size_and_chunk - chunk", int_chunk)
    return chunk
  
  fn read_int_chunk(self, f: FileHandle, pos: Int) raises -> ReadResult:
    let new_read = self.read_from_file(f, pos, 4, True)
    # Need to convert the bytes in new_read.data to a UInt32
    var size: UInt32 = 0
    for i in range(0, 4):
      size |= new_read.data[i].cast[DType.uint32]() << ((3 - i) * 8)
    let result = ReadResult(pos, size.to_int(), DynamicVector[UInt8]())
    self.print_result("read_int_chunk", result)
    return result 

  fn print_byte_vector(self, data: DynamicVector[UInt8]) raises:
    for i in range(0, data.__len__()):
      printf("%02x ", data[i])
    print()

  fn read_from_file(self, f: FileHandle, pos: Int, size: Int, advance: Bool) raises -> ReadResult:
    var data = DynamicVector[UInt8]()
    var pos2 = pos
    _ = f.seek(pos2)
    # f.read_bytes forces the use of a SIMD[si64, 1] for `size`
    # and a Tensor[DType.int8] for the return type!
    let t_si8: Tensor[DType.int8] = f.read_bytes(size)
    let t_ui8: Tensor[DType.uint8] = t_si8.astype[DType.uint8]()
    for i in range(0, t_ui8.num_elements()):
      data.push_back(t_ui8[i]) 
    if advance: 
      pos2 = pos2 + size
    return ReadResult(pos2, size, data)

fn main() raises:
  # from sys.param_env import env_get_int, env_get_string
  # print(env_get_int["boo"]()) 
  let args = sysutils.get_params()
  if args.len() == 0:
    print("Usage: mojo preset_parser <preset file>")
    return
  let filename = sysutils.get_app_path() + args[0]
  print("filemame: " + filename)
  let parser = Parser()
  parser.process_preset(filename, True)


  
