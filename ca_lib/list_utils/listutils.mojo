from ..list import List

@value
struct lu:
  
  @staticmethod
  fn strs_to_str(input_list: List[String]) raises -> String:
    var result: String = "["
    for i in range(len(input_list)):
      let repr = "'" + str(input_list[i]) + "'"
      if i != len(input_list) - 1:
        result += repr + ", "
      else:
        result += repr
    return result + "]"

  @staticmethod
  fn ints_to_str(input_list: List[Int]) raises -> String:
    var result: String = "["
    for i in range(len(input_list)):
      let repr = str(input_list.__getitem__(index=i))
      if i != len(input_list) - 1:
        result += repr + ", "
      else:
        result += repr
    return result + "]"
