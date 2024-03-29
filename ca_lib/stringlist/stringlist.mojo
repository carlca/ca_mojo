from collections.vector import DynamicVector

struct StringListIter:
  var data: StringList
  var idx: Int

  fn __init__(inout self, data: StringList):
    self.idx = -1
    self.data = data

  fn __len__(self) -> Int:
    return self.data.size() - self.idx - 1 

  fn __next__(inout self) raises -> String:
    self.idx += 1
    return self.data[self.idx]

@value
struct StringList(Stringable, Sized):
  """This does not have the same behavior as python at all regarding references.
  But it helps us code things without having real lists available, and it's memory efficient.
  Replace with the list provided by mojo ASAP.

  This was adapted from work done by @gabrieldemarmiesse. I added the iterator behaviour.
  """

  var _internal_string: String
  var _end_of_strings: DynamicVector[Int]

  fn __init__(inout self):
    self._internal_string = ""
    self._end_of_strings = DynamicVector[Int]()

  fn __init__(inout self, input_value: String):
    self._internal_string = ""
    self._end_of_strings = DynamicVector[Int]()
    for i in range(len(input_value)):
      self.append(input_value[i])

  fn __copyinit__(inout self, other: Self):
    self._internal_string = other._internal_string
    self._end_of_strings = other._end_of_strings

  fn append(inout self, value: String):
    self._internal_string += value
    self._end_of_strings.push_back(len(self._internal_string))

  fn __iadd__(inout self, value: String):
    self.append(value)

  fn __getitem__(self, index: Int) raises -> String:
    if index >= len(self._end_of_strings):
      raise Error("list index out of range")
    var start: Int
    if index == 0:
      start = 0
    else:
      start = self._end_of_strings[index - 1]
    return self._internal_string[start : self._end_of_strings[index]]

  fn __getitem__(self: Self, limits: Slice) raises -> Self:
    var new_list: Self = Self()
    for i in range(limits.start, limits.end, limits.step):
      new_list.append(self.__getitem__(i))
    return new_list

  fn __len__(self) -> Int:
    return len(self._end_of_strings)

  fn __eq__(self: Self, other: Self) raises -> Bool:
    if self.len() == 0 and other.len() == 0:
      return True
    if self.len() != other.len():
      return False
    for i in range(self.len()):
      if self[i] != other[i]:
        return False
    return True

  fn size(self) -> Int:
    return self.__len__()

  fn len(self) -> Int:
    return self.__len__()

  fn __str__(self: Self) -> String:
    var result: String = "["
    for i in range(self.__len__()):
      try: result += self.__getitem__(i) except Error: pass
      if i < self.__len__() - 1:
        result += ", "
    result += "]"
    return result

  fn __iter__(self: Self) -> StringListIter:
    return self

  fn str(borrowed self) raises -> String:
    return self.__str__()

  fn first(self) raises -> String:
    if self.__len__() > 0:
      return self.__getitem__(0)
    return ""

  fn last(self) raises -> String:
    if self.__len__() > 0:
      return self.__getitem__(self.__len__() - 1)
    return ""

  fn last_n(self, n: Int) raises -> StringList:
    if self.__len__() > 0:
      var result: StringList = StringList()
      for i in range(self.len() - n, self.len()):
        result.append(self.__getitem__(i))
      return result
    return StringList()

  fn first_n(self, n: Int) raises -> StringList:
    if self.__len__() > 0:
      var result: StringList = StringList()
      for i in range(0, n):
        result.append(self.__getitem__(i))
      return result
    return StringList()

  fn all_but_last_n(self, n: Int) raises -> StringList:
    if self.__len__() > 0:
      var result: StringList = StringList()
      for i in range(0, self.len() - n):
        result.append(self.__getitem__(i))
      print(result)  
      return result
    return StringList()

  fn all_but_first_n(self, n: Int) raises -> StringList:
    if self.__len__() > 0:
      var result: StringList = StringList()
      for i in range(n, self.len()):
        result.append(self.__getitem__(i))
      return result
    return StringList()

  fn join(self, sep: String) raises -> String:
    return self.join(sep, False)

  fn join(self, sep: String, ensure_final_sep: Bool) raises -> String:
    var result: String = ""
    var final_offset: Int  
    if ensure_final_sep:
      final_offset = 0
    else:
      final_offset = 1
    if self.__len__() == 0:
      return result
    for i in range(self.__len__()):
      result += self.__getitem__(i)
      if i < self.__len__() - final_offset:
        result += sep
    return result