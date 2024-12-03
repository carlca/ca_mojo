from listt import List

struct ListIter[T: AnyType]:
  var data: List[T]
  var idx: Int

  fn __init__(out self, data: List[T]):
    self.idx = -1
    self.data = data

  fn __len__(self) -> Int:
    return self.data.size - self.idx - 1

  fn __next__(out self) -> T:
    self.idx += 1
    return self.data[self.idx]
