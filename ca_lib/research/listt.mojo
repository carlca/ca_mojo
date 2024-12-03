from utils.vector import DynamicVector
from listt_iter import ListIter

@value
struct List[T: AnyType]:
  """This does not have the same behavior as python at all regarding references.
  But it helps us code things without having real lists available, and it's memory efficient.
  Replace by the list provided by mojo ASAP.
  """

  var _internal_string: String
  var _end_of_strings: DynamicVector[Int]
  var iter_index: Int

  fn __init__(out self):
    self._internal_string = ""
    self._end_of_strings = DynamicVector[Int]()
    self.iter_index = 0

  fn __init__(out self, input_value: String):
    self._internal_string = ""
    self._end_of_strings = DynamicVector[Int]()
    for i in range(len(input_value)):
      self.append(input_value[i])

  fn append(out self, value: String):
    self._internal_string += value
    self._end_of_strings.push_back(len(self._internal_string))

  fn __getitem__(self, index: Int) raises -> String:
    if index >= len(self._end_of_strings):
      raise Error("list index out of range")
    var start: Int
    if index == 0:
      start = 0
    else:
      start = self._end_of_strings[index - 1]
    return self._internal_string[start : self._end_of_strings[index]]

  fn __getitem__(self: Self, limits: slice) raises -> Self:
    var new_list: Self = Self()
    for i in range(limits.start, limits.end, limits.step):
      new_list.append(self.__getitem__(i))
    return new_list

  fn __len__(self) -> Int:
    return len(self._end_of_strings)

  fn __str__(self: Self) raises -> String:
    var result: String = "["
    for i in range(self.__len__()):
      result += "'" + self.__getitem__(i) + "'"
      if i < self.__len__() - 1:
        result += ", "
    result += "]"
    return result

  fn __iter__(self) -> ListIter[T]:
    return ListIter(self)

  fn str(borrowed self) raises -> String:
    var result: String = ""
    for i in range(self.__len__()):
      result += self.__getitem__(i)
      if i < self.__len__() - 1: result += "\n"
    return result
