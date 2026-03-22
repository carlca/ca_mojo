from array_iter import ArrayIter

struct Array[T: AnyType]:
  var data: Pointer[T]
  var size: Int

  def __init__(out self, size: Int):
    self.size = size
    self.data = Pointer[T].alloc(self.size)

  def __init__(out self, size: Int, default: T):
    self.size = size
    self.data = Pointer[T].alloc(self.size)
    for i in range(self.size):
      self.data.store(i, default)

  def __getitem__(self, i: Int) -> T:
    return self.data.load(i)

  def __moveinit__(out self, owned existing: Self):
    self.size = existing.size
    self.data = existing.data
    existing.size = 0
    existing.data = Pointer[T].alloc(0)

  def __setitem__(out self, i: Int, value: T):
    self.data.store(i, value)

  def __del__(owned self):
    self.data.free()

  def __len__(self) -> Int:
    return self.size

  def __iter__(self) -> ArrayIter[T]:
    return ArrayIter(self)

  def __copyinit__(out self, other: Self):
    self.size = other.size
    self.data = Pointer[T].alloc(self.size)
    memcpy[T](self.data, other.data, self.size)
