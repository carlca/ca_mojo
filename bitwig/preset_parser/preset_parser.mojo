from tensor import Tensor, TensorSpec, TensorShape
from ca_lib.stringlist import StringList
from builtin.io import _printf as printf
from ca_lib.sys_utils import sysutils 

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
    var pos = 0x36

    var f = open(file_name, "rb")
    while True:
      let result = self.read_key_and_value(f, pos, debug)
      print(result.__str__())
      pos = result.pos
      if result.size == 0: break
    f.close()

  fn read_key_and_value(borrowed self, f: FileHandle, pos: Int, debug: Bool) raises -> ReadResult:
    var pos2 = pos
    var skips = self.get_skip_size(f, pos2)
    if debug:
      self.get_skip_size_debug(f, pos2)
      print(String(skips) + " skips")
    pos2 += skips

    var result = self.read_next_size_and_chunk(f, pos2)
    pos2 = result.pos
    var size = result.size
    var data = result.data
    if size == 0: return ReadResult(0, 0, DynamicVector[UInt8]())
    self.print_output(pos2, size, data)

    skips = self.get_skip_size(f, pos2)
    if debug:
      self.get_skip_size_debug(f, pos2)
      print(String(skips) + " skips")
    pos2 += skips

    result = self.read_next_size_and_chunk(f, pos2)
    pos2 = result.pos
    size = result.size
    data = result.data
    self.print_output(pos2, size, data)
    print()
    return ReadResult(pos2, size, DynamicVector[UInt8]())

  fn print_output(self, pos: Int, size: Int, data: DynamicVector[UInt8]) raises:
    printf("pos: %d  size: %d  data: ")
    for i in range(0, data.__len__()):
      printf("%02x ", data[i])
    print()  

  fn get_skip_size(borrowed self, f: FileHandle, pos: Int) raises -> Int:
    let bytes = self.read_from_file(f, pos, 32, True).data
    for i in range(0, bytes.__len__()):
      if bytes[i] >= 0x20 and (i == 5 or i == 8 or i == 13):
        return i - 4
    return 1

  fn get_skip_size_debug(borrowed self, f: FileHandle, pos: Int) raises:
    let bytes = self.read_from_file(f, pos, 32, True).data
    for b in range(0, bytes.__len__()):
      printf("%02x ", b)
    print()
    for b in range(0, bytes.__len__()):
      if b >= 0x41:
        printf(".%c.", b)
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
    return self.read_from_file(f, int_chunk.pos, int_chunk.size, True);
  
  fn read_int_chunk(self, f: FileHandle, pos: Int) raises -> ReadResult:
    let new_read = self.read_from_file(f, pos, 4, True)
    return ReadResult(new_read.pos, 0, new_read.data)

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


  
