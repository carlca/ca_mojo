from matrix import Matrix
from testing import assert_equal

  fn test_init():
    var m = Matrix(2, 3)
    if assert_equal(m.rows, 2): print("Matrix has correct number of rows")
    if assert_equal(m.cols, 3): print("Matrix has correct number of columns")
    if assert_equal(m.get_data_as_string(), "[[0.0, 0.0, 0.0], [0.0, 0.0, 0.0]]"): print("Matrix has correct data")

  fn test_add():
    var m1 = Matrix(2, 3)
    var m2 = Matrix(2, 3)
    m1.data = [[1, 2, 3], [4, 5, 6]]
    m2.data = [[7, 8, 9], [10, 11, 12]]
    var m3 = m1 + m2
    _ = assert_equal(m3.data, [[8, 10, 12], [14, 16, 18]])

  fn test_sub():
    var m1 = Matrix(2, 3)
    var m2 = Matrix(2, 3)
    m1.data = [[1, 2, 3], [4, 5, 6]]
    m2.data = [[7, 8, 9], [10, 11, 12]]
    var m3 = m1 - m2
    self.assert_equal(m3.data, [[-6, -6, -6], [-6, -6, -6]])

  fn test_mul(self):
    m1 = Matrix(2, 3)
    m2 = Matrix(3, 2)
    m1.data = [[1, 2, 3], [4, 5, 6]]
    m2.data = [[7, 8], [9, 10], [11, 12]]
    m3 = m1 * m2
    self.assert_equal(m3.data, [[58, 64], [139, 154]])

  def test_mul_scalar(self):
    m1 = Matrix(2, 3)
    m1.data = [[1, 2, 3], [4, 5, 6]]
    m2 = m1 * 2
    self.assert_equal(m2.data, [[2, 4, 6], [8, 10, 12]])

  fn test_transpose(self):
    m1 = Matrix(2, 3)
    m1.data = [[1, 2, 3], [4, 5]]
    m2 = m1.transpose()
    self.assert_equal(m2.data, [[1, 4], [2, 5], [3]])

  fn test_map(self):
    m1 = Matrix(2, 3)
    m1.data = [[1, 2, 3], [4, 5, 6]]
    m2 = m1.map(lambda x: x * 2)
    self.assert_equal(m2.data, [[2, 4, 6], [8, 10, 12]])

  fn test_map_static(self):
    m1 = Matrix(2, 3)
    m1.data = [[1, 2, 3], [4, 5, 6]]
    m2 = Matrix.map_static(m1, lambda x: x * 2)
    self.assert_equal(m2.data, [[2, 4, 6], [8, 10, 12]])

  