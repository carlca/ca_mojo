from std.collections import List
from std.utils.variant import Variant
from std.reflection import source_location

comptime TestFn = def() raises thin -> Tuple[Bool, String]

@fieldwise_init
struct Passed(Writable, Copyable, Movable):
   var name: String
   
   def write_to(self, mut writer: Some[Writer]):
      writer.write("Passed(", self.name, ")")

@fieldwise_init
struct Failed(Writable, Copyable, Movable):
   var name: String

   def write_to(self, mut writer: Some[Writer]):
      writer.write("Failed(", self.name, ")")


@fieldwise_init
struct Raised(Writable, Copyable, Movable):
   var message: String

   def write_to(self, mut writer: Some[Writer]):
      var message = self.message
      if not message:
         writer.write("Raised an exception")
      else:
         writer.write("Raised an exception", message)

comptime TestResult = Variant[Passed, Failed, Raised]

@fieldwise_init
struct TeeTest(Copyable, Movable):
   var tests: List[TestFn]

   def __init__(out self, *tests: TestFn):
      self.tests = List[TestFn]()
      for test in tests:      ## Line 36
         self.add_test(test)  ## Line 37

   def count(self) -> Int:
      return len(self.tests)

   def add_test(mut self, func: TestFn):
      self.tests.append(func)

   @staticmethod
   def _run_test(f: TestFn) -> TestResult:
      var succeeded: Bool
      var source_loc: String
      try:
         succeeded, source_loc = f()
      except e:
         return Raised(String(e))
      return TestResult(Passed(source_loc)) if succeeded
         else TestResult(Failed(source_loc))

   @staticmethod
   def _res_to_str(self: TestResult) -> String:
      if self.isa[Passed]():
         return String(self[Passed])
      elif self.isa[Failed]():
         return String(self[Failed])
      else:
         return String(self[Raised])

   def run_tests(self, failed_only: Bool = True) raises:
      var succ_count = 0
      var fail_count = 0
      for i in range(self.count()):
         var res = self._run_test(self.tests[i])

         var loc = self._res_to_str(res)
         var file_name: String; var line: Int; var success: String
         file_name, line, _, success = self.unpack_loc(loc)
         with open(file_name, "r") as f:
            var s = f.read()
            var code_lines = s.split("\n")

            # Find the last line that begins with "def test" before index: line
            var fn_name_line: String = ""
            for j in range(line - 1, -1, -1):
               if code_lines[j].strip().startswith("def test"):
                  fn_name_line = String(code_lines[j])
                  break

            var fn_name = fn_name_line[byte=:fn_name_line.find("()")]
            var str = "Test " + String(i + 1) + ": " + fn_name + ": " + success

            if res.isa[Passed]():
               succ_count += 1
               if not failed_only: print(str)
            else:
               fail_count += 1
               print(str)
      print("\n--------------------------------------------")
      print(" Total number of tests run: ", self.count())
      print("    Number of tests passed: ", succ_count)
      print("    Number of tests failed: ", fail_count)
      print("--------------------------------------------")

   @staticmethod
   def unpack_loc(loc: String) raises -> Tuple[String, Int, Int, String]:
      var content = loc[byte=loc.find("(")+1:-1]
      var parts = content.split(":")
      var file_name = String(":".join(parts[:-2]))
      var line = parts[len(parts)-2].__int__()
      var col = parts[len(parts)-1].__int__()
      return (file_name, line, col, "")
