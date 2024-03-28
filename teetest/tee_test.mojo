from collections import List
from builtin.io import _printf as printf
from utils.variant import Variant

alias TestFn = fn() raises -> Tuple[Bool, StringLiteral]

@value
struct Passed(CollectionElement, Stringable):
  var name: String
  fn __str__(self) -> String:
    return "\"" + self.name + "\": passed!"

@value
struct Failed(CollectionElement, Stringable):
  var name: String
  fn __str__(self) -> String:
    return "\"" + self.name + "\": failed!"

@value
struct Raised(CollectionElement, Stringable):
  var message: String
  fn __str__(self) -> String:
    var message = self.message
    if not message:
      return "(null): raised an exception!"
    return "(null): raised an exception with message: " + message

alias TestResult = Variant[Passed, Failed, Raised]

@value
struct TeeTest:
  var tests: List[TestFn]

  fn __init__(inout self, *tests: TestFn):
    self.tests = List[TestFn]()
    for test in tests:
      self.add_test(test)

  fn count(self) -> Int:
    return len(self.tests)

  fn add_test(inout self, func: TestFn):
    self.tests.append(func)

  @staticmethod
  fn _run_test(f: TestFn) -> TestResult:
    var function_name: StringLiteral
    var succeeded: Bool
    try:
      succeeded, function_name = f()
    except e:
      return Raised(e)
    return TestResult(Passed(function_name)) if succeeded
      else TestResult(Failed(function_name))

  @staticmethod
  fn _res_to_str(self: TestResult) -> String:
    if self.isa[Passed]():
      return str(self.get[Passed]()[])
    elif self.isa[Failed]():
      return str(self.get[Failed]()[])
    else:
      return str(self.get[Raised]()[])

  fn run_tests(self, failed_only: Bool = True):
    var succ_count = 0
    var fail_count = 0
    for i in range(self.count()):
      var res = self._run_test(self.tests[i])
      var str = "Test " + str(i + 1) + ", " + self._res_to_str(res)
      if res.isa[Passed]():
        succ_count += 1
        if not failed_only: print(str)
      else:
        fail_count += 1
        print(str)
    print("--------------------------------------------")
    print(" Total number of tests run: ", self.count())
    print("    Number of tests passed: ", succ_count)
    print("    Number of tests failed: ", fail_count)
    print("--------------------------------------------")
