from matrix import Matrix
from testing import assert_equal 

fn main():
  var m = Matrix(2, 3)
  if assert_equal(m.rows, 2): print("Matrix has correct number of rows")
  if assert_equal(m.cols, 3): print("Matrix has correct number of columns")
  if assert_equal(m.get_data_as_string(), "[[0.0, 0.0, 0.0], [0.0, 0.0, 0.0]]"): print("Matrix has correct data")
  
