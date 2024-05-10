from collections import List
from builtin.io import _printf as printf
from utils.variant import Variant
from builtin._location import __source_location

alias TestFn = fn() raises -> Tuple[Bool, String]

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
    var succeeded: Bool
    var source_loc: String
    try:
      succeeded, source_loc = f()
    except e:
      return Raised(e)
    return TestResult(Passed(source_loc)) if succeeded
      else TestResult(Failed(source_loc))

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
    printf("\n")
    print("--------------------------------------------")
    print(" Total number of tests run: ", self.count())
    print("    Number of tests passed: ", succ_count)
    print("    Number of tests failed: ", fail_count)
    print("--------------------------------------------")
