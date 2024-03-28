from collections import List

@value
struct su:

  @staticmethod
  fn __string__mul__(input_string: String, n: Int) -> String:
    var result: String = ""
    for _ in range(n):
      result += input_string
    return result

  @staticmethod
  fn rjust(input_string: String, width: Int, fillchar: String = " ") raises -> String:
    if len(fillchar) != 1:
      raise Error(" The fill character must be exactly one character long")
    var extra = width - len(input_string)
    return su.__string__mul__(fillchar, extra) + input_string

  @staticmethod
  fn ljust(input_string: String, width: Int, fillchar: String = " ") raises -> String:
    if len(fillchar) != 1:
      raise Error(" The fill character must be exactly one character long")
    var extra = width - len(input_string)
    return input_string + su.__string__mul__(fillchar, extra)

  @staticmethod
  fn endswith(input_string: String, suffix: String, start: Int = 0, owned end: Int = -1) raises -> Bool:
    if end == -1:
      end = len(input_string)
    if end < start:
      raise Error("The end index must be greater than or equal to the start index")
    if end - start < len(suffix):
      return False
    return input_string[end - len(suffix) : end] == suffix

  @staticmethod
  fn trim(s: String, leading: String, trailing: String) -> String:
    var start = 0
    var end = len(s)
    while start < end and s[start] == leading:
      start += 1
    while end > start and s[end - 1] == trailing:
      end -= 1
    return s[start:end]

  @staticmethod
  fn find(s: String, sub: String) -> Int:
    return su.find(s, sub, 0)

  @staticmethod
  fn find(s: String, sub: String, start: Int) -> Int:
    var len = s.__len__()
    var sub_len = sub.__len__()
    for i in range(start, len - sub_len + 1):
      var is_match = True
      for j in range(sub_len):
        if s[i + j] != sub[j]:
          is_match = False
          break
      if is_match:
        return i
    return -1

  @staticmethod
  fn split_to_strings(s: String, sep: String) -> String:
    var s1 = s
    var result = String()
    var index: Int = su.find(s1, sep, 0)
    while index >= 0:
      result += s1[0:index] + "\n"
      s1 = s1[index + len(sep):len(s1)]
      index = su.find(s1, sep, 0)
    if len(s1) > 0:
      result += s1
    return result

  @staticmethod
  fn split(s: String, sep: String) -> List[String]:
    var s1 = s
    var result: List[String] = List[String]()
    var index: Int = su.find(s1, sep, 0)
    while index >= 0:
      result.append(s1[0:index])
      s1 = s1[index + len(sep):len(s1)]
      index = su.find(s1, sep, 0)
    if len(s1) > 0:
      result.append(s1)
    return result

  @staticmethod
  fn remove_char(s: String, char: String) -> String:
    var result = String()
    if char.__len__() == 1:
      var c: String = ""
      for i in range(len(s)):
        c = s[i]
        if c != char:
          result += c
    return result

  @staticmethod
  fn count_char(s: String, char: String) -> Int:
    var count = 0
    if char.__len__() == 1:
      for i in range(len(s)):
        if s[i] == char:
          count += 1
    return count

  @staticmethod
  fn substr(s: String, start: Int, length: Int) -> String:
    return s[start:start+length]

  @staticmethod
  fn substr(s: String, start: Int) -> String:
    var length = len(s) - start
    return s[start:start+length]

  @staticmethod
  fn build_string(char: String, length: Int) -> String:
    var result = String()
    for _ in range(length):
      result += char
    return result

