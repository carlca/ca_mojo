from tensor import Tensor, TensorSpec, TensorShape
from builtin.io import _printf as printf

@value
struct ReadResult(StringableRaising):
  var pos: Int
  var size: Int
  var data: List[UInt8]

  fn __str__(self) raises -> String:
    var result = "pos: " + str(self.pos) + " size: " + str(self.size) + " data: [" 
    for i in range(0, self.data.__len__()):
      result += str(self.data[i]) + " "
    result += "]"  
    return result

struct PresetParser:
  var debug: Bool

  fn __init__(inout self) raises:
    self.debug = False

  fn process_preset(borrowed self, file_name: String) raises:
    var pos: Int = 0x36

    var f = open(file_name, "r")
    while True:
      var result = self.read_key_and_value(f, pos)
      pos = result.pos
      if result.size == 0: break
    f.close()

  fn read_key_and_value(borrowed self, f: FileHandle, inout pos: Int) raises -> ReadResult:
    var skips = self.get_skip_size(f, pos)
    if self.debug:
      self.get_skip_size_debug(f, pos)
      print(str(skips) + " skips")
    pos += skips

    var result = self.read_next_size_and_chunk(f, pos)
    pos = result.pos
    var size = result.size
    var data = result.data
    if size == 0: return ReadResult(0, 0, List[UInt8]())
    printf["[%s] "](self.vec_to_string(data))

    skips = self.get_skip_size(f, pos)
    if self.debug:
      self.get_skip_size_debug(f, pos)
      print(str(skips) + " skips")
    pos += skips

    result = self.read_next_size_and_chunk(f, pos)
    printf["%s\n"](self.vec_to_string(result.data))
    return ReadResult(result.pos, result.size, List[UInt8]())

  fn get_skip_size(borrowed self, f: FileHandle, inout pos: Int) raises -> Int:
    var bytes = self.read_from_file(f, pos, 32, True).data
    for i in range(0, bytes.__len__()):
      if bytes[i] >= 0x20 and (i == 5 or i == 8 or i == 13):
        return i - 4
    return 1

  fn get_skip_size_debug(borrowed self, f: FileHandle, inout pos: Int) raises:
    var bytes = self.read_from_file(f, pos, 32, True).data
    for b in range(0, bytes.__len__()):
      printf["%02x "](bytes[b])
    print()
    for b in range(0, bytes.__len__()):
      if bytes[b] >= 0x31:
        printf[".%c."](bytes[b])
      else:
        printf["   "]()
    print()

  fn read_next_size_and_chunk(self, f: FileHandle, inout pos: Int) raises -> ReadResult:
    var int_chunk = self.read_int_chunk(f, pos);
    if (int_chunk.size == 0):
      return ReadResult(pos, 0, List[UInt8]())
    return self.read_from_file(f, int_chunk.pos, int_chunk.size, True)
    
  fn read_int_chunk(self, f: FileHandle, inout pos: Int) raises -> ReadResult:
    var new_read = self.read_from_file(f, pos, 4, True)
    if new_read.data.size == 0:
      return ReadResult(0, 0, List[UInt8]())
    pos = new_read.pos
    var size: UInt32 = 0
    for i in range(0, 4):
      size |= new_read.data[i].cast[DType.uint32]() << ((3 - i) * 8)
    return ReadResult(pos, size.__int__(), List[UInt8]())

  @staticmethod
  fn print_byte_vector(data: List[UInt8]) raises:
    for i in range(0, data.__len__()):
      printf["%02x "](data[i])
    print()

  @staticmethod
  fn read_from_file(f: FileHandle, pos: Int, size: Int, advance: Bool) raises -> ReadResult:
    var data = List[UInt8]()
    try:
      _ = f.seek(pos)
    except:
      return ReadResult(0, 0, List[UInt8]())
    var t_ui8: Tensor[DType.uint8] = f.read_bytes(size)
    for i in range(0, t_ui8.num_elements()):
      data.append(t_ui8[i]) 
    var increment = 0
    if advance: 
      increment = size
    return ReadResult(pos + increment, size, data)

  @staticmethod
  fn vec_to_string(data: List[UInt8]) raises -> String:
    var result = String()
    for i in range(0, len(data)):
      if data[i] == 0x00:
        break
      result += chr(data[i].__int__())
    return result


  
