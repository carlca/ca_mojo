from collections.vector import DynamicVector
from builtin.io import _printf as printf

alias TestFn = fn() raises -> (Bool, StringLiteral)

@value
@register_passable
struct CollectionElementWrapper[T: AnyRegType](CollectionElement):
    var wrappee: T

alias TestFnPtrWrapper = CollectionElementWrapper[Pointer[TestFn]]

struct TeeTest:
  var tests: DynamicVector[TestFnPtrWrapper]

  fn __init__(inout self):
    self.tests = DynamicVector[TestFnPtrWrapper]()

  fn count(self) -> Int:
    return self.tests.__len__()

  fn add_test(inout self, func: TestFn) -> None:
    var ptr = Pointer[TestFn].alloc(1)
    ptr.store(func)
    self.tests.push_back(ptr)

  fn run_tests(self):
    self.run_tests(True)

  fn run_tests(self, fails_only: Bool):
    var fail_count = 0
    var succ_count = 0
    try:
      for i in range(self.tests.__len__()):
        var test_fn = self.tests[i].wrappee.load()  # THAT's what you do with "wrappee" ;)
        var function_name: StringLiteral
        var succeeded: Bool
        (succeeded, function_name) = test_fn()
        if not succeeded:
          printf("Test %d, \"%s\": failed!\n", i + 1, function_name)
          fail_count += 1
        else:
          succ_count += 1
          if not fails_only:
            printf("Test %d, \"%s\": passed!\n", i + 1, function_name)
      print("--------------------------------------------")
      print(" Total number of tests run: ", fail_count + succ_count)
      print("    Number of tests passed: ", succ_count)
      print("    Number of tests failed: ", fail_count)
      print("--------------------------------------------")
    except:
      None