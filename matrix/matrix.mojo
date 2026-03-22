from std.memory.unsafe_pointer import UnsafePointer, memcpy

from string_utils import su
from float_utils import fu

comptime DataType = UnsafePointer[mut=True, Scalar[DType.float64], MutExternalOrigin]

struct Matrix(ImplicitlyCopyable):
   '''Simple 2d matrix that uses Float64.'''
   comptime __copyinit__is_trivial = False

   var rows: Int
   var cols: Int
   var total_items: Int
   var data: DataType
   var debugging: Bool

   def __init__(out self, *, rows: Int, cols: Int):
      self.debugging = False
      self.rows = rows if rows > 0 else 1
      self.cols = cols if cols > 0 else 1
      self.total_items = self.rows * self.cols
      self.data = alloc[Scalar[DType.float64]](self.total_items)
      for i in range(self.total_items):
         DataType.store(self.data, i, 0.0)

   def __init__(out self, *, content: String) raises:
      self.debugging = True
      self.rows = 0
      self.cols = 0
      self.total_items = 0
      self.data = alloc[Scalar[DType.float64]](1)
      var s = content
      s = su.remove_char(s, " ")
      s = su.trim(s, "[", "]")
      s = su.trim(s, "'", "'")
      var rows = su.split(s, "],[")
      var last_count = 0
      # Check if all rows in `content` have the same number of columns
      try:
         for row in rows:
            var this_count = su.count_char(row, ",")
            if this_count != last_count and last_count != 0:
               print("Error: Matrix dimensions of `content` must match")
            else:
               # Parse each row of `content` and store it in `self`
               self.rows = len(rows)
               self.cols = this_count + 1
               self.total_items = self.rows * self.cols
               self.data = alloc[Scalar[DType.float64]](self.total_items)
               var i = 0
               for row in rows:
                  var cols = su.split(row, ",")
                  for col in cols:
                     var f = fu.str_to_float(col)
                     DataType.store(self.data, i, f)
                     i += 1
      except:
         None

   def __init__(out self, *, copy: Matrix):
      self.rows = copy.rows
      self.cols = copy.cols
      self.total_items = copy.total_items
      self.debugging = copy.debugging
      self.data = alloc[Scalar[DType.float64]](self.total_items)
      memcpy[Float64](dest=self.data, src=copy.data, count=self.total_items)

   def dbg(read self, msg: String, value: String) -> None:
      if self.debugging:
         print(msg, value)

   def dbg(read self, msg: String, value: Int) -> None:
      if self.debugging:
         print(msg, value)

   def __getitem__(read self, row: Int, col: Int) -> Float64:
      var index = row * self.cols + col
      if index < 0 or index >= self.total_items:
         print("Error: Index out of bounds")
         return 0.0
      return self.data.load[width=1](index)

   def __setitem__(mut self, row: Int, col: Int, value: Float64) -> None:
      var index = row * self.cols + col
      if index < 0 or index >= self.total_items:
         print("Error: Index out of bounds")
         return
      DataType.store(self.data, index, value)

   def __del__(deinit self) -> None:
      self.data.free()

   def __len__(read self) -> Int:
      return self.total_items

   def __eq__ (read self, other: Matrix) -> Bool:
      for i in range(self.rows):
         for j in range(self.cols):
            if self[i, j] != other[i, j]:
               return False
      return True

   def __ne__ (read self, other: Matrix) -> Bool:
      return not (self == other)

   def __add__ (read self, other: Matrix) -> Matrix:
      if self.rows != other.rows or self.cols != other.cols:
         print("Error: Matrix dimensions must match")
         return Matrix(rows=1, cols=1)
      var result = Matrix(rows=self.rows, cols=self.cols)
      for i in range(self.rows):
         for j in range(self.cols):
            result[i, j] = self[i, j] + other[i, j]
      return result

   def __iadd__ (mut self, other: Matrix) -> None:
      self = self + other

   def __sub__ (read self, other: Matrix) -> Matrix:
      if self.rows != other.rows or self.cols != other.cols:
         print("Error: Matrix dimensions must match")
         return Matrix(1, 1)
      var result = Matrix(self.rows, self.cols)
      for i in range(self.rows):
         for j in range(self.cols):
            result[i, j] = self[i, j] - other[i, j]
      return result

   def __isub__ (mut self: Matrix, other: Matrix) -> None:
      self = self - other

   def __mul__ (read self, other: Matrix) -> Matrix:
      if self.cols != other.rows:
         print("Error: Matrix dimensions must match")
         return Matrix(1, 1)
      var result = Matrix(rows=self.rows, cols=other.cols)
      for i in range(self.rows):
         for j in range(other.cols):
            for k in range(self.cols):
               result[i, j] += self[i, k] * other[k, j]
      return result

   def __truediv__ (read self, other: Matrix) -> Matrix:
      if self.rows != other.rows or self.cols != other.cols:
         print("Error: Matrix dimensions must match")
         return Matrix(rows=1, cols=1)
      var result = Matrix(rows=self.rows, cols=self.cols)
      for i in range(self.rows):
         for j in range(self.cols):
            result[i, j] = self[i, j] / other[i, j]
      return result

   def __add__ (read self, other: Float64) -> Matrix:
      var result = Matrix(rows=self.rows, cols=self.cols)
      for i in range(self.rows):
         for j in range(self.cols):
            result[i, j] = self[i, j] + other
      return result

   def __iadd__ (mut self: Matrix, other: Float64) -> None:
      self = self + other

   def __sub__ (read self, other: Float64) -> Matrix:
      var result = Matrix(self.rows, self.cols)
      for i in range(self.rows):
         for j in range(self.cols):
            result[i, j] = self[i, j] - other
      return result

   def __isub__ (mut self: Matrix, other: Float64) -> None:
      self = self - other

   def __mul__ (read self, other: Float64) -> Matrix:
      var result = Matrix(self.rows, self.cols)
      for i in range(self.rows):
         for j in range(self.cols):
            result[i, j] = self[i, j] * other
      return result

   def __imul__ (mut self: Matrix, other: Float64) -> None:
      self = self * other

   def __truediv__ (read self, other: Float64) -> Matrix:
      var result = Matrix(self.rows, self.cols)
      for i in range(self.rows):
         for j in range(self.cols):
            result[i, j] = self[i, j] / other
      return result

   def __itruediv__ (mut self: Matrix, other: Float64) -> None:
      self = self / other

   def __neg__ (read self) -> Matrix:
      var result = Matrix(self.rows, self.cols)
      for i in range(self.rows):
         for j in range(self.cols):
            result[i, j] = -self[i, j]
      return result

   def apply_func [func: fn(Float64) -> Float64](read self) -> Matrix:
      var result = Matrix(self.rows, self.cols)
      for i in range(self.rows):
         for j in range(self.cols):
            result[i, j] = func(self[i, j])
      return result

   def transpose (read self) -> Matrix:
      var result = Matrix(self.cols, self.rows)
      for i in range(self.rows):
         for j in range(self.cols):
            result[j, i] = self[i, j]
      return result

   def print (read self) -> None:
      print(self.get_data_as_string())

   def print_to(read self, places: Int) -> None:
      print(self.get_data_as_string(places))

   def get_data_as_string(read self) -> String:
      return self.get_data_as_string(0)

   def string_to(read self, places: Int) -> String:
      return self.get_data_as_string(places)

   def get_data_as_string(read self, places: Int) -> String:
      var result: String = "["
      for i in range(self.rows):
         result += "["
         for j in range(self.cols):
            if places == 0:
               result += String(self[i, j])
            else:
               result += fu.format_float(self[i, j], places)
            if j != self.cols - 1:
               result += ", "
         result = result + "], " if i != self.rows - 1 else result + "]"
      result = result + "]"
      return result

   def print_shape (read self) -> None:
      print("(", self.rows, ", ", self.cols, ")")

   def get_shape (read self) -> Tuple[Int, Int]:
      return (self.rows, self.cols)

   def get_row (read self, row: Int) -> Matrix:
      var result = Matrix(1, self.cols)
      for i in range(self.cols):
         result[0, i] = self[row, i]
      return result

   def get_col (read self, col: Int) -> Matrix:
      var result = Matrix(self.rows, 1)
      for i in range(self.rows):
         result[i, 0] = self[i, col]
      return result

   def set_row (mut self: Matrix, row: Int, other: Matrix):
      if other.rows != 1 or other.cols != self.cols:
         print("Error: Matrix dimensions must match")
         return
      for i in range(self.cols):
         self[row, i] = other[0, i]

   def set_col (mut self: Matrix, col: Int, other: Matrix):
      if other.rows != self.rows or other.cols != 1:
         print("Error: Matrix dimensions must match")
         return
      for i in range(self.rows):
         self[i, col] = other[i, 0]

   def get_slice (read self, row_start: Int, row_end: Int, col_start: Int, col_end: Int) -> Matrix:
      if row_start < 0 or row_start >= self.rows or row_end < 0 or row_end >= self.rows
         or col_start < 0 or col_start >= self.cols or col_end < 0 or col_end >= self.cols:
         print("Error: Index out of bounds")
         return Matrix(1, 1)
      var result = Matrix(row_end - row_start + 1, col_end - col_start + 1)
      for i in range(row_start, row_end + 1):
         for j in range(col_start, col_end + 1):
            result[i - row_start, j - col_start] = self[i, j]
      return result

   def set_slice (mut self: Matrix, row_start: Int, row_end: Int, col_start: Int, col_end: Int, other: Matrix) -> None:
      if row_start < 0 or row_start >= self.rows or row_end < 0 or row_end >= self.rows or col_start < 0 or col_start >= self.cols or col_end < 0 or col_end >= self.cols:
         print("Error: Index out of bounds")
         return
      if other.rows != row_end - row_start + 1 or other.cols != col_end - col_start + 1:
         print("Error: Matrix dimensions must match")
         return
      for i in range(row_start, row_end + 1):
         for j in range(col_start, col_end + 1):
            self[i, j] = other[i - row_start, j - col_start]

   def get_slice_row (read self, row_start: Int, row_end: Int) -> Matrix:
      return self.get_slice(row_start, row_end, 0, self.cols - 1)

   def set_slice_row (mut self: Matrix, row_start: Int, row_end: Int, other: Matrix) -> None:
      self.set_slice(row_start, row_end, 0, self.cols - 1, other)

   def get_slice_col (read self, col_start: Int, col_end: Int) -> Matrix:
      return self.get_slice(0, self.rows - 1, col_start, col_end)

   def set_slice_col (mut self: Matrix, col_start: Int, col_end: Int, other: Matrix) -> None:
      self.set_slice(0, self.rows - 1, col_start, col_end, other)

   def get_slice_row (read self, row: Int) -> Matrix:
      return self.get_slice(row, row, 0, self.cols - 1)

   def set_slice_row (mut self: Matrix, row: Int, other: Matrix):
      self.set_slice(row, row, 0, self.cols - 1, other)

   def get_slice_col (read self, col: Int) -> Matrix:
      return self.get_slice(0, self.rows - 1, col, col)

   def set_slice_col (mut self: Matrix, col: Int, other: Matrix):
      self.set_slice(0, self.rows - 1, col, col, other)

   def get_slice_row (read self, row_start: Int, row_end: Int, col: Int) -> Matrix:
      return self.get_slice(row_start, row_end, col, col)

   def set_slice_row (mut self: Matrix, row_start: Int, row_end: Int, col: Int, other: Matrix):
      self.set_slice(row_start, row_end, col, col, other)

   def get_slice_col (read self, row: Int, col_start: Int, col_end: Int) -> Matrix:
      return self.get_slice(row, row, col_start, col_end)

   def set_slice_col (mut self: Matrix, row: Int, col_start: Int, col_end: Int, other: Matrix):
      self.set_slice(row, row, col_start, col_end, other)
