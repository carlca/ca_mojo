from math import max
from collections import List

from ..string_utils import su
from ..float_utils import fu

struct Matrix:
  '''Simple 2d matrix that uses Float64.'''

  var rows: Int
  var cols: Int
  var total_items: Int
  var data: DTypePointer[DType.float64]
  var debugging: Bool

  fn __init__(inout self, rows: Int, cols: Int) -> None:
    self.debugging = False
    self.rows = rows if rows > 0 else 1
    self.cols = cols if cols > 0 else 1 
    self.total_items = self.rows * self.cols
    self.data = Pointer[Float64].alloc(self.total_items) 
    for i in range(self.total_items):
      self.data.store(i, 0.0)

  fn __init__(inout self, content: String) raises -> None:
    self.debugging = True	
    self.rows = 0
    self.cols = 0
    self.total_items = 0
    self.data = Pointer[Float64].alloc(1)
    var s = content
    s = su.remove_char(s, " ")
    s = su.trim(s, "[", "]")
    s = su.trim(s, "'", "'")
    var rows = su.split(s, "],[")
    var this_count = 0
    var last_count = 0
    # Check if all rows in `content` have the same number of columns 
    try:
      for row in rows:
        this_count = su.count_char(row[], ",")
        if this_count != last_count and last_count != 0:
          print("Error: Matrix dimensions of `content` must match")
        else:
          # Parse each row of `content` and store it in `self`
          self.rows = rows.size
          self.cols = this_count + 1
          self.total_items = self.rows * self.cols
          self.data = Pointer[Float64].alloc(self.total_items)
          var i = 0
          for row in rows:
            var cols = su.split(row[], ",")
            for col in cols:
              var f = fu.str_to_float(col[])
              self.data.store(i, f)
              i += 1
    except:
      None

  fn dbg(borrowed self, msg: String, value: String) -> None:
    if self.debugging:
      print(msg, value)

  fn dbg(borrowed self, msg: String, value: Int) -> None:
    if self.debugging:
      print(msg, value)

  fn __getitem__(borrowed self, row: Int, col: Int) -> Float64:
    var index = row * self.cols + col
    if index < 0 or index >= self.total_items:
      print("Error: Index out of bounds")
      return 0.0
    return self.data.load(index)

  fn __setitem__(inout self, row: Int, col: Int, value: Float64) -> None:
    var index = row * self.cols + col
    if index < 0 or index >= self.total_items:
      print("Error: Index out of bounds")
      return
    self.data.store(index, value)

  fn __del__(owned self) -> None:
    self.data.free()	

  fn __len__(borrowed self) -> Int:
    return self.total_items

  fn __copyinit__(inout self, other: Matrix) -> None:
    self.rows = other.rows
    self.cols = other.cols
    self.total_items = other.total_items
    self.debugging = other.debugging
    self.data = DTypePointer[DType.float64].alloc(self.total_items)
    memcpy(self.data, other.data, self.total_items)

  fn __eq__ (borrowed self, other: Matrix) -> Bool:
    for i in range(self.rows):
      for j in range(self.cols):
        if self[i, j] != other[i, j]:
          return False
    return True

  fn __ne__ (borrowed self, other: Matrix) -> Bool:
    return not (self == other)

  fn __add__ (borrowed self, other: Matrix) -> Matrix:
    if self.rows != other.rows or self.cols != other.cols:
      print("Error: Matrix dimensions must match")
      return Matrix(1, 1)
    var result = Matrix(self.rows, self.cols)
    for i in range(self.rows):
      for j in range(self.cols):
        result[i, j] = self[i, j] + other[i, j]
    return result

  fn __iadd__ (inout self: Matrix, other: Matrix) -> None:
    self = self + other

  fn __sub__ (borrowed self, other: Matrix) -> Matrix:
    if self.rows != other.rows or self.cols != other.cols:
      print("Error: Matrix dimensions must match")
      return Matrix(1, 1)
    var result = Matrix(self.rows, self.cols)
    for i in range(self.rows):
      for j in range(self.cols):
        result[i, j] = self[i, j] - other[i, j]
    return result

  fn __isub__ (inout self: Matrix, other: Matrix) -> None:
    self = self - other

  fn __mul__ (borrowed self, other: Matrix) -> Matrix:
    if self.cols != other.rows:
      print("Error: Matrix dimensions must match")
      return Matrix(1, 1)
    var result = Matrix(self.rows, other.cols)
    for i in range(self.rows):
      for j in range(other.cols):
        for k in range(self.cols):
          result[i, j] += self[i, k] * other[k, j]
    return result

  fn __truediv__ (borrowed self, other: Matrix) -> Matrix:
    if self.rows != other.rows or self.cols != other.cols:
      print("Error: Matrix dimensions must match")
      return Matrix(1, 1)
    var result = Matrix(self.rows, self.cols)
    for i in range(self.rows):
      for j in range(self.cols):
        result[i, j] = self[i, j] / other[i, j]
    return result

  fn __add__ (borrowed self, other: Float64) -> Matrix:
    var result = Matrix(self.rows, self.cols)
    for i in range(self.rows):
      for j in range(self.cols):
        result[i, j] = self[i, j] + other
    return result

  fn __iadd__ (inout self: Matrix, other: Float64) -> None:
    self = self + other

  fn __sub__ (borrowed self, other: Float64) -> Matrix:
    var result = Matrix(self.rows, self.cols)
    for i in range(self.rows):
      for j in range(self.cols):
        result[i, j] = self[i, j] - other
    return result

  fn __isub__ (inout self: Matrix, other: Float64) -> None:
    self = self - other

  fn __mul__ (borrowed self, other: Float64) -> Matrix:
    var result = Matrix(self.rows, self.cols)
    for i in range(self.rows):
      for j in range(self.cols):
        result[i, j] = self[i, j] * other
    return result

  fn __imul__ (inout self: Matrix, other: Float64) -> None:
    self = self * other

  fn __truediv__ (borrowed self, other: Float64) -> Matrix:
    var result = Matrix(self.rows, self.cols)
    for i in range(self.rows):
      for j in range(self.cols):
        result[i, j] = self[i, j] / other
    return result

  fn __itruediv__ (inout self: Matrix, other: Float64) -> None:
    self = self / other

  fn __neg__ (borrowed self) -> Matrix:
    var result = Matrix(self.rows, self.cols)
    for i in range(self.rows):
      for j in range(self.cols):
        result[i, j] = -self[i, j]
    return result	

  fn apply_func [func: fn(Float64) -> Float64](borrowed self) -> Matrix:
    var result = Matrix(self.rows, self.cols)
    for i in range(self.rows):
      for j in range(self.cols):
        result[i, j] = func(self[i, j])
    return result

  fn transpose (borrowed self) -> Matrix:
    var result = Matrix(self.cols, self.rows)
    for i in range(self.rows):
      for j in range(self.cols):
        result[j, i] = self[i, j]
    return result

  fn print (borrowed self) -> None:
    print(self.get_data_as_string())

  fn print_to(borrowed self, places: Int) -> None:
    print(self.get_data_as_string(places))
  
  fn get_data_as_string(borrowed self) -> String:
    return self.get_data_as_string(0)

  fn string_to(borrowed self, places: Int) -> String:
    return self.get_data_as_string(places)

  fn get_data_as_string(borrowed self, places: Int) -> String:
    var result: String = "["
    for i in range(self.rows):
      result += "["
      for j in range(self.cols):
        if places == 0:
          result += self[i, j]
        else:
          result += fu.format_float(self[i, j], places)
        if j != self.cols - 1:
          result += ", "
      result = result + "], " if i != self.rows - 1 else result + "]"
    result = result + "]"
    return result

  fn print_shape (borrowed self) -> None:
    print("(", self.rows, ", ", self.cols, ")")

  fn get_shape (borrowed self) -> Tuple[Int, Int]:
    return (self.rows, self.cols)

  fn get_row (borrowed self, row: Int) -> Matrix:
    var result = Matrix(1, self.cols)
    for i in range(self.cols):
      result[0, i] = self[row, i]
    return result

  fn get_col (borrowed self, col: Int) -> Matrix:
    var result = Matrix(self.rows, 1)
    for i in range(self.rows):
      result[i, 0] = self[i, col]
    return result

  fn set_row (inout self: Matrix, row: Int, other: Matrix) -> None:
    if other.rows != 1 or other.cols != self.cols:
      print("Error: Matrix dimensions must match")
      return
    for i in range(self.cols):
      self[row, i] = other[0, i]

  fn set_col (inout self: Matrix, col: Int, other: Matrix) -> None:
    if other.rows != self.rows or other.cols != 1:
      print("Error: Matrix dimensions must match")
      return
    for i in range(self.rows):
      self[i, col] = other[i, 0]

  fn get_slice (borrowed self, row_start: Int, row_end: Int, col_start: Int, col_end: Int) -> Matrix:
    if row_start < 0 or row_start >= self.rows or row_end < 0 or row_end >= self.rows 
      or col_start < 0 or col_start >= self.cols or col_end < 0 or col_end >= self.cols:
      print("Error: Index out of bounds")
      return Matrix(1, 1)
    var result = Matrix(row_end - row_start + 1, col_end - col_start + 1)
    for i in range(row_start, row_end + 1):
      for j in range(col_start, col_end + 1):
        result[i - row_start, j - col_start] = self[i, j]
    return result

  fn set_slice (inout self: Matrix, row_start: Int, row_end: Int, col_start: Int, col_end: Int, other: Matrix) -> None:
    if row_start < 0 or row_start >= self.rows or row_end < 0 or row_end >= self.rows or col_start < 0 or col_start >= self.cols or col_end < 0 or col_end >= self.cols:
      print("Error: Index out of bounds")
      return
    if other.rows != row_end - row_start + 1 or other.cols != col_end - col_start + 1:
      print("Error: Matrix dimensions must match")
      return
    for i in range(row_start, row_end + 1):
      for j in range(col_start, col_end + 1):
        self[i, j] = other[i - row_start, j - col_start]

  fn get_slice_row (borrowed self, row_start: Int, row_end: Int) -> Matrix:
    return self.get_slice(row_start, row_end, 0, self.cols - 1)

  fn set_slice_row (inout self: Matrix, row_start: Int, row_end: Int, other: Matrix) -> None:
    self.set_slice(row_start, row_end, 0, self.cols - 1, other)

  fn get_slice_col (borrowed self, col_start: Int, col_end: Int) -> Matrix:
    return self.get_slice(0, self.rows - 1, col_start, col_end)

  fn set_slice_col (inout self: Matrix, col_start: Int, col_end: Int, other: Matrix) -> None:
    self.set_slice(0, self.rows - 1, col_start, col_end, other)	

  fn get_slice_row (borrowed self, row: Int) -> Matrix:
    return self.get_slice(row, row, 0, self.cols - 1)

  fn set_slice_row (inout self: Matrix, row: Int, other: Matrix) -> None:
    self.set_slice(row, row, 0, self.cols - 1, other)

  fn get_slice_col (borrowed self, col: Int) -> Matrix:
    return self.get_slice(0, self.rows - 1, col, col)

  fn set_slice_col (inout self: Matrix, col: Int, other: Matrix) -> None:
    self.set_slice(0, self.rows - 1, col, col, other)

  fn get_slice_row (borrowed self, row_start: Int, row_end: Int, col: Int) -> Matrix:
    return self.get_slice(row_start, row_end, col, col)

  fn set_slice_row (inout self: Matrix, row_start: Int, row_end: Int, col: Int, other: Matrix) -> None:
    self.set_slice(row_start, row_end, col, col, other)

  fn get_slice_col (borrowed self, row: Int, col_start: Int, col_end: Int) -> Matrix:
    return self.get_slice(row, row, col_start, col_end)

  fn set_slice_col (inout self: Matrix, row: Int, col_start: Int, col_end: Int, other: Matrix) -> None:
    self.set_slice(row, row, col_start, col_end, other)
