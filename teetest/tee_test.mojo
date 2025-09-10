from collections import List
from builtin.io import _printf as printf
from utils.variant import Variant
from builtin._location import __source_location

alias TestFn = fn() raises -> Tuple[Bool, String]

@fieldwise_init
struct Passed(Stringable, Copyable, Movable):
   var name: String
   fn __str__(self) -> String:
      return "\"" + self.name + "\": passed!"

@fieldwise_init
struct Failed(Stringable, Copyable, Movable):
   var name: String
   fn __str__(self) -> String:
      return "\"" + self.name + "\": failed!"

@fieldwise_init
struct Raised(Stringable, Copyable, Movable):
   var message: String
   fn __str__(self) -> String:
      var message = self.message
      if not message:
         return "(null): raised an exception!"
      return "(null): raised an exception with message: " + message

alias TestResult = Variant[Passed, Failed, Raised]

@fieldwise_init
struct TeeTest(Copyable, Movable):
   var tests: List[TestFn]

   fn __init__(out self, *tests: TestFn):
      self.tests = List[TestFn]()
      for test in tests:
         self.add_test(test)

   fn count(self) -> Int:
      return len(self.tests)

   fn add_test(mut self, func: TestFn):
      self.tests.append(func)

   @staticmethod
   fn _run_test(f: TestFn) -> TestResult:
      var succeeded: Bool
      var source_loc: String
      try:
         succeeded, source_loc = f()
      except e:
         return Raised(String(e))
      return TestResult(Passed(source_loc)) if succeeded
         else TestResult(Failed(source_loc))

   @staticmethod
   fn _res_to_str(self: TestResult) -> String:
      if self.isa[Passed]():
         return String(self[Passed])
      elif self.isa[Failed]():
         return String(self[Failed])
      else:
         return String(self[Raised])

   fn run_tests(self, failed_only: Bool = True) raises:
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
            var line_str = code_lines[line - 1].removesuffix(",")
            if i == 0: print("")
            var str = "Test " + String(i + 1) + " - " + line_str.lstrip() + ":" + success

            if res.isa[Passed]():
               succ_count += 1
               if not failed_only: print(str)
            else:
               fail_count += 1
               print(str)
      print("\n--------------------------------------------")
      print(" Total number of tests run: ", self.count())
      print("      Number of tests passed: ", succ_count)
      print("      Number of tests failed: ", fail_count)
      print("--------------------------------------------")

   @staticmethod
   fn unpack_loc(loc: String) raises -> Tuple[String, Int, Int, String]:
      var parts = loc.split(":")
      return (String(parts[0][1:]), parts[1].__int__(), parts[2][:-1].__int__(), String(parts[3]))
