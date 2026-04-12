from std.collections import List

comptime TestFn = def() raises thin -> Tuple[Bool, String]

struct TeeTest:
   var tests: List[TestFn]

   def __init__(out self, *tests: TestFn):
      self.tests = List[TestFn]()
      for test in tests:
          self.add_test(test)

   def add_test(mut self, func: TestFn):
      self.tests.append(func)

def main():
   _ = TeeTest()