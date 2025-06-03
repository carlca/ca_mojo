alias Bytes = List[Byte]

@value
struct ReadResult(Boolable, Stringable):
  var pos: Int
  var size: Int
  var data: Bytes

  fn __bool__(self) -> Bool:
    return self.size > 0

  fn __str__(self) -> String:
    var data = String()
    for b in self.data:
      data.write(b, " ")
    return String(
      "pos: ", self.pos, ", ",
      "size: ", self.size, ", ",
      "data: [", data[:-1] if data else "", "]"
    )

struct PresetParser:
  var debug: Bool

  fn __init__(out self):
    self.debug = False

  fn process_preset(self, file_name: String) raises:
    var pos: Int = 0x36

    var f = open(file_name, "r")
    while True:
      var result = self.read_key_and_value(f, pos)
      pos = result.pos
      if result.size == 0: break
    f.close()

  fn read_key_and_value(self, f: FileHandle, mut pos: Int) raises -> ReadResult:
    var skips = self.get_skip_size(f, pos)
    if self.debug:
      self.get_skip_size_debug(f, pos)
      print(skips, "skips")
    pos += skips

    var result = self.read_next_size_and_chunk(f, pos)
    pos = result.pos
    var size = result.size
    var data = result.data
    if size == 0: return ReadResult(0, 0, Bytes())
    print(String("[{0}] ").format(self.vec_to_string(data)), end="")

    skips = self.get_skip_size(f, pos)
    if self.debug:
      self.get_skip_size_debug(f, pos)
      print(skips, "skips")
    pos += skips

    result = self.read_next_size_and_chunk(f, pos)
    print(String("{0}").format(self.vec_to_string(result.data)))

    return ReadResult(result.pos, result.size, Bytes())

  fn get_skip_size(self, f: FileHandle, mut pos: Int) raises -> Int:
    var bytes = self.read_from_file(f, pos, 32, True).data
    for i in range(len(bytes)):
      if bytes[i] >= 0x20 and (i == 5 or i == 8 or i == 13):
        return i - 4
    return 1

  fn get_skip_size_debug(self, f: FileHandle, mut pos: Int) raises:
    var bytes = self.read_from_file(f, pos, 32, True).data
    print("")
    for b in range(len(bytes)):
      print(String("{:02x} ").format(bytes[b]), end="")
      # printf["%02x "](bytes[b])
    print()
    for b in range(len(bytes)):
      if bytes[b] >= 0x31:
        print(String("{.%c.} ").format(bytes[b]), end="")
        # printf[".%c."](bytes[b])
      else:
        print("   ")
    print()

  fn read_next_size_and_chunk(self, f: FileHandle, mut pos: Int) raises -> ReadResult:
    var int_chunk = self.read_int_chunk(f, pos)
    if not int_chunk:
      return ReadResult(pos, 0, Bytes())
    return self.read_from_file(f, int_chunk.pos, int_chunk.size, True)

  fn read_int_chunk(self, f: FileHandle, mut pos: Int) raises -> ReadResult:
    var new_read = self.read_from_file(f, pos, 4, True)
    if not new_read.data:
      return ReadResult(0, 0, Bytes())
    pos = new_read.pos
    var size: UInt32 = 0
    for i in range(4):
      size |= new_read.data[i].cast[DType.uint32]() << ((3 - i) * 8)
    return ReadResult(pos, Int(size), Bytes())

  @staticmethod
  fn print_byte_vector(data: Bytes) raises:
    for i in range(len(data)):
      print(String("%02x ").format(data[i]), end="")
    print()

  @staticmethod
  fn read_from_file(f: FileHandle, pos: Int, size: Int, advance: Bool) raises -> ReadResult:
    try:
      _ = f.seek(pos)
    except:
      return ReadResult(0, 0, Bytes())
    var data: Bytes = f.read_bytes(size)
    return ReadResult(pos + size if advance else 0, size, data)

  @staticmethod
  fn vec_to_string(data: Bytes) -> String:
    var result = String()
    for i in range(len(data)):
      if data[i] == 0x00:
        break
      result += chr(data[i].__int__())
    return result
